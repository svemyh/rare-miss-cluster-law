"""Rebuild and audit the full fixed-budget cluster law without model calls."""

from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import subprocess
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parent
BUILD = ROOT / 'build'
ALLOWED_AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}
PIN = '905b95818eb32af7874a58b427f50c1711a5e96c'
UPSTREAM_PIN = '58b321e9c9b86448e4fdd897a428c8cef7297f5e'
MAIN_THEOREM = 'MissedUpdates.Matrices.rare_miss_cluster_law'
NEGATIVE_CONTROLS = {
    'RejectAllMisses': ('unsolved goals', 'could not prove'),
    'RejectFalseGain': ('unsolved goals', 'could not prove'),
    'RejectShiftedCoefficient': ('Type mismatch',),
    'RejectMissingStrictPositivity': ('Application type mismatch',),
}


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def lean_code(source):
    """Remove nested comments and strings while preserving lines for token checks."""
    result = []
    index = 0
    depth = 0
    in_string = False
    while index < len(source):
        pair = source[index:index + 2]
        char = source[index]
        if depth:
            if pair == '/-':
                depth += 1
                index += 2
            elif pair == '-/':
                depth -= 1
                index += 2
            else:
                result.append('\n' if char == '\n' else ' ')
                index += 1
        elif in_string:
            if char == '\\':
                index += 2
            else:
                in_string = char != '"'
                result.append('\n' if char == '\n' else ' ')
                index += 1
        elif pair == '/-':
            depth = 1
            result.append(' ')
            index += 2
        elif pair == '--':
            end = source.find('\n', index)
            index = len(source) if end < 0 else end
        elif char == '"':
            in_string = True
            result.append(' ')
            index += 1
        else:
            result.append(char)
            index += 1
    require(depth == 0 and not in_string, 'Unterminated Lean comment or string')
    return ''.join(result)


def main():
    BUILD.mkdir(exist_ok=True)
    env = os.environ.copy()
    local_bin = Path(env.get('LEAN_BIN_DIR', str(ROOT / '.toolchain' / 'bin')))
    if (local_bin / 'lake').is_file():
        env['PATH'] = str(local_bin) + os.pathsep + env.get('PATH', '')
    lake = shutil.which('lake', path=env.get('PATH'))
    require(lake is not None, 'Install the pinned Lean toolchain or set LEAN_BIN_DIR')

    def run(args, logfile, expected_failure=(), timeout=900):
        result = subprocess.run(args, cwd=ROOT, env=env, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                timeout=timeout, check=False)
        (BUILD / logfile).write_text(result.stdout)
        if expected_failure:
            require(result.returncode != 0, f'False statement was accepted: {args[-1]}')
            require(any(message in result.stdout for message in expected_failure),
                    f'Negative control failed for an unexpected reason: {logfile}')
        else:
            require(result.returncode == 0, f'Command failed; inspect build/{logfile}')
        return result.stdout

    version = run([lake, 'env', 'lean', '--version'], 'version.txt')
    require('version 4.32.2,' in version, 'Unexpected Lean version')
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
    upstream = json.loads((ROOT/'licenses/UPSTREAM-HASHES.json').read_text())
    require(upstream['commit'] == UPSTREAM_PIN, 'Upstream proof pin changed')
    upstream_files = sorted([*ROOT.glob('PF/**/*.lean'), *ROOT.glob('MCMC/**/*.lean')])
    require({str(p.relative_to(ROOT)) for p in upstream_files} == set(upstream['sha256']),
            'Upstream proof inventory changed')
    for path in upstream_files:
        require(sha(path) == upstream['sha256'][str(path.relative_to(ROOT))],
                'Modified upstream proof source: '+str(path.relative_to(ROOT)))

    sources = [ROOT / 'MissedUpdates.lean', *sorted((ROOT / 'MissedUpdates').glob('*.lean'))]
    declarations = []
    for path in sources:
        text = lean_code(path.read_text())
        require(not re.search(r'\b(sorry|admit|axiom|unsafe|native_decide|implemented_by|extern)\b', text),
                'Forbidden proof escape token in '+path.name)
        require('skipKernelTC' not in text, 'Kernel check bypass in '+path.name)
        namespace = []
        for line in text.splitlines():
            if line.startswith('namespace '):
                namespace.append(line.split()[1])
            elif line.startswith('end '):
                require(namespace and namespace[-1] == line.split()[1], 'Unrecognized namespace layout')
                namespace.pop()
            elif line.startswith(('theorem ', 'lemma ')):
                declarations.append('.'.join([*namespace,line.split()[1]]))
    require(declarations, 'No theorem declarations found')
    require(MAIN_THEOREM in declarations, 'Main theorem missing')
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
    run([lake, 'env', 'lean', '--trust=0', 'MainAudit.lean'], 'main-trust-zero.txt')
    run([lake, 'env', 'lean', '--trust=0', 'checks/PositiveControl.lean'], 'positive-control.txt')
    run([lake, 'env', 'lean', '--trust=0', 'checks/MainConsumer.lean'], 'main-consumer.txt')
    for name, reasons in NEGATIVE_CONTROLS.items():
        run([lake, 'env', 'lean', '--trust=0', f'checks/{name}.lean'], name+'.txt', expected_failure=reasons)

    for source in (ROOT / 'MissedUpdates').glob('*.lean'):
        obj = ROOT / '.lake' / 'build' / 'lib' / 'lean' / 'MissedUpdates' / (source.stem+'.olean')
        require(obj.is_file(), 'Missing compiled module: '+source.name)
    inputs = [*sources, *upstream_files, ROOT/'licenses/UPSTREAM-HASHES.json',
              ROOT/'AxiomAudit.lean',ROOT/'MainAudit.lean',ROOT/'lakefile.toml',ROOT/'lake-manifest.json',
              ROOT/'lean-toolchain',ROOT/'check.py', *sorted((ROOT/'checks').glob('*.lean'))]
    receipt = {
        'status': 'PASS',
        'scope': 'Full fixed-budget cluster growth law for strictly positive finite matrices',
        'full_growth_rate_theorem_formalized': True,
        'main_theorem': MAIN_THEOREM,
        'checked_at_utc': datetime.now(timezone.utc).isoformat(),
        'rate_definition': 'limsup_N sup over infinite admissible sequences of matrix norm^(1/N)',
        'matrix_norm': 'elementwise maximum norm',
        'normalization': 'ordinary complex spectral radius of the real success matrix',
        'coefficient': 'max(1,S_1,...,S_m), genuine finite integer-gap suprema',
        'lean_version': version.strip(), 'dependency_revisions': pins,
        'upstream_proof_repository': upstream['repository'],
        'upstream_proof_commit': UPSTREAM_PIN,
        'upstream_proof_files_hash_verified': len(upstream_files),
        'dependency_sources_clean': True, 'trust_level': 0,
        'theorems_checked': len(declarations), 'axioms_by_theorem': parsed,
        'permitted_foundational_axioms': sorted(ALLOWED_AXIOMS),
        'custom_mathematical_axioms': [], 'proof_escape_tokens': [],
        'negative_controls_rejected': list(NEGATIVE_CONTROLS),
        'source_sha256': {str(path.relative_to(ROOT)):sha(path) for path in inputs},
        'remaining_formalization_obligations_for_main_theorem': [],
        'not_claimed': ['Publication novelty', 'Human specialist review',
                        'Formalization of every separate application in the manuscript'],
    }
    (BUILD/'receipt.json').write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
    print(json.dumps({key:receipt[key] for key in ('status','scope','theorems_checked',
                      'trust_level','custom_mathematical_axioms','negative_controls_rejected')},indent=2))


if __name__ == '__main__':
    main()
