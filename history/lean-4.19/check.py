"""Build and audit the partial Lean development, without paid model calls."""

from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent
BUILD = ROOT / 'build'
ALLOWED_AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}
PIN = 'c44e0c8ee63ca166450922a373c7409c5d26b00b'


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    BUILD.mkdir(exist_ok=True)
    env = os.environ.copy()
    local_bin = Path(env.get('LEAN_BIN_DIR', str(ROOT / '.toolchain' / 'bin')))
    if (local_bin / 'lake').is_file():
        env['PATH'] = str(local_bin) + os.pathsep + env.get('PATH', '')
    lake = shutil.which('lake', path=env.get('PATH'))
    require(lake is not None, 'Install the pinned Lean toolchain or set LEAN_BIN_DIR')

    def run(args, logfile, expected_failure=False, timeout=900):
        result = subprocess.run(args, cwd=ROOT, env=env, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                timeout=timeout, check=False)
        (BUILD / logfile).write_text(result.stdout)
        if expected_failure:
            require(result.returncode != 0, f'False statement was accepted: {args[-1]}')
            require('unsolved goals' in result.stdout or 'could not prove' in result.stdout,
                    f'Negative control failed for an unexpected reason: {logfile}')
        else:
            require(result.returncode == 0, f'Command failed; inspect build/{logfile}')
        return result.stdout

    version = run([lake, 'env', 'lean', '--version'], 'version.txt')
    require('version 4.19.0,' in version, 'Unexpected Lean version')
    manifest = json.loads((ROOT / 'lake-manifest.json').read_text())
    pins = {}
    for package in manifest['packages']:
        directory = ROOT / manifest['packagesDir'] / package['name']
        head = subprocess.run(['git','-C',str(directory),'rev-parse','HEAD'], check=True,
                              capture_output=True,text=True).stdout.strip()
        require(head == package['rev'], 'Dependency revision mismatch: '+package['name'])
        dirty = subprocess.run(['git','-C',str(directory),'status','--porcelain','--untracked-files=no'],
                               check=True,capture_output=True,text=True).stdout
        require(not dirty.strip(), 'Modified dependency sources: '+package['name'])
        pins[package['name']] = head
    require(pins['mathlib'] == PIN, 'Mathlib pin changed')

    sources = [ROOT / 'MissedUpdates.lean', *sorted((ROOT / 'MissedUpdates').glob('*.lean'))]
    declarations = []
    for path in sources:
        text = path.read_text()
        require(not re.search(r'\b(sorry|admit|axiom|unsafe|native_decide)\b', text),
                'Forbidden proof escape token in '+path.name)
        namespace = []
        for line in text.splitlines():
            if line.startswith('namespace '):
                namespace.append(line.split()[1])
            elif line.startswith('end '):
                require(namespace and namespace[-1] == line.split()[1], 'Unrecognized namespace layout')
                namespace.pop()
            elif line.startswith('theorem '):
                declarations.append('.'.join([*namespace,line.split()[1]]))
    require(declarations, 'No theorem declarations found')
    audit_text = (ROOT / 'AxiomAudit.lean').read_text()
    audited = [line.removeprefix('#print axioms ').strip() for line in audit_text.splitlines()
               if line.startswith('#print axioms ')]
    require(sorted(declarations) == sorted(audited), 'Axiom audit does not cover every exported theorem')

    run([lake, 'build'], 'lake-build.txt')
    audit = run([lake, 'env', 'lean', '--trust=0', 'AxiomAudit.lean'], 'axioms-trust-zero.txt')
    parsed = {}
    pattern = r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)"
    for match in re.finditer(pattern, audit, re.MULTILINE):
        names = {item.strip() for item in (match.group(2) or '').split(',') if item.strip()}
        require(names <= ALLOWED_AXIOMS, 'Unexpected axiom dependency: '+str(names-ALLOWED_AXIOMS))
        parsed[match.group(1)] = sorted(names)
    require(set(parsed) == set(declarations), 'Could not parse every axiom result')
    run([lake, 'env', 'lean', 'checks/PositiveControl.lean'], 'positive-control.txt')
    for name in ('RejectAllMisses', 'RejectFalseGain'):
        run([lake, 'env', 'lean', f'checks/{name}.lean'], name+'.txt', expected_failure=True)

    for source in (ROOT / 'MissedUpdates').glob('*.lean'):
        obj = ROOT / '.lake' / 'build' / 'lib' / 'lean' / 'MissedUpdates' / (source.stem+'.olean')
        require(obj.is_file(), 'Missing compiled module: '+source.name)
    inputs = [*sources, ROOT/'AxiomAudit.lean',ROOT/'lakefile.toml',ROOT/'lake-manifest.json',
              ROOT/'lean-toolchain',ROOT/'check.py', *sorted((ROOT/'checks').glob('*.lean'))]
    receipt = {
        'status': 'PASS', 'scope': 'Kernel-checked proof components, not the complete paper theorem',
        'full_growth_rate_theorem_formalized': False,
        'lean_version': version.strip(), 'dependency_revisions': pins,
        'dependency_sources_clean': True, 'trust_level': 0,
        'theorems_checked': len(declarations), 'axioms_by_theorem': parsed,
        'permitted_foundational_axioms': sorted(ALLOWED_AXIOMS),
        'custom_mathematical_axioms': [], 'proof_escape_tokens': [],
        'negative_controls_rejected': ['RejectAllMisses','RejectFalseGain'],
        'source_sha256': {str(path.relative_to(ROOT)):sha(path) for path in inputs},
        'remaining': [
            'Positivity-to-Perron-data/convergence theorem',
            'Assemble the canonical word decomposition with the matrix-product upper bound',
            'Define the exact constrained growth rate and prove both scaled limit bounds',
        ],
    }
    (BUILD/'receipt.json').write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
    print(json.dumps({key:receipt[key] for key in ('status','scope','theorems_checked',
                      'trust_level','custom_mathematical_axioms','negative_controls_rejected')},indent=2))


if __name__ == '__main__':
    main()
