"""Validate the tracked research package without network access or writes."""

from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
FORBIDDEN = {'.lake', '.toolchain', '.toolchains', '.downloads', '.codex', '.claude', '__pycache__', 'build'}
TEXT = {'.md', '.lean', '.py', '.json', '.toml', '.mjs', '.tex', '.bib'}
SECRETS = [re.compile(pattern) for pattern in (
    rb'gh[pousr]_[A-Za-z0-9]{20,}', rb'github_pat_[A-Za-z0-9_]{30,}',
    rb'AKIA[A-Z0-9]{16}', rb'sk-(?:proj-|ant-)?[A-Za-z0-9_-]{30,}',
    rb'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----')]
PRIVATE_PATH = re.compile(rb'/(?:Users|home)/[A-Za-z0-9_.-]+/')
CONTROL = re.compile(rb'[\x00-\x08\x0b\x0c\x0e-\x1f]')
LINK = re.compile(r'\[[^\]\n]+\]\(([^)\n]+)\)')


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(relative):
    return json.loads((ROOT / relative).read_text())


def main():
    git_root = subprocess.check_output(['git', '-C', str(ROOT), 'rev-parse', '--show-toplevel'], text=True).strip()
    require(Path(git_root).resolve() == ROOT, 'Expected the standalone repository, not its parent')
    names = subprocess.check_output(['git', '-C', str(ROOT), 'ls-files', '-z']).decode().split('\0')
    names = [name for name in names if name]
    required = {'README.md', 'Makefile', 'THEOREM.md', 'verify.py', 'lean/MissedUpdates/Main.lean',
                'lean/AxiomAudit.lean', 'lean/licenses/UPSTREAM-HASHES.json', 'paper/rare_misses.pdf',
                'evidence/lean/receipt.json', 'evidence/manuscript/qa-review.json',
                'QUANTITATIVE.md', 'quantitative.py', 'fixtures/quantitative-reset.json',
                'tests/test_quantitative.py', 'evidence/quantitative/reset-certificate.json'}
    require(required <= set(names), 'Missing package files: '+str(sorted(required-set(names))))
    total = links = 0
    for name in names:
        relative, path = Path(name), ROOT / name
        require(not (set(relative.parts) & FORBIDDEN), 'Excluded runtime file tracked: '+name)
        require(not relative.name.startswith('.env'), 'Environment file tracked: '+name)
        require(not path.is_symlink() and path.is_file(), 'Missing/non-regular tracked file: '+name)
        # The retained OpenAlex citation response is approximately 2.6 MB.
        require(path.stat().st_size < 4 * 1024 * 1024, 'Unexpectedly large file: '+name)
        if relative.suffix == '.pdf':
            require(name == 'paper/rare_misses.pdf', 'Unexpected PDF: '+name)
        data = path.read_bytes()
        total += len(data)
        if relative.suffix in TEXT or relative.name in {'Makefile', '.gitignore', 'lean-toolchain'}:
            require(not PRIVATE_PATH.search(data), 'Private machine path in '+name)
            require(not CONTROL.search(data), 'Unexpected control character in '+name)
            require(not any(pattern.search(data) for pattern in SECRETS), 'Possible credential in '+name)
        if relative.suffix == '.md':
            for target in LINK.findall(data.decode('utf-8')):
                target = target.strip('<>')
                if target.startswith('#') or urlsplit(target).scheme:
                    continue
                destination = (path.parent / unquote(target.split('#')[0].split('?')[0])).resolve()
                require(destination.is_relative_to(ROOT) and destination.exists(), 'Broken/outside link in '+name+': '+target)
                links += 1
    require(total < 10 * 1024 * 1024, 'Package exceeds the expected source-only size')
    require(links >= 20, 'Unexpectedly few local links were checked')
    proof = read_json('evidence/lean/receipt.json')
    require(proof['status'] == 'PASS' and proof['full_growth_rate_theorem_formalized'], 'Full proof pass missing')
    require(proof['trust_level'] == 0 and proof['theorems_checked'] == 201, 'Proof audit scope changed')
    require('MissedUpdates.Matrices.all_later_windows_accuracy' in proof['quantitative_theorems'],
            'Quantitative accuracy implication missing from the proof receipt')
    require(proof['custom_mathematical_axioms'] == [], 'Unexpected mathematical axioms')
    for name, expected in proof['source_sha256'].items():
        require('lean/'+name in names, 'Proof receipt names an untracked input: '+name)
        require(digest(ROOT/'lean'/name) == expected, 'Proof receipt mismatch: '+name)
    exact = read_json('evidence/exact/check-results.json')
    require(exact['status'] == 'PASS', 'Exact verification failed')
    for name, expected in exact['inputs_sha256'].items():
        require(digest(ROOT/name) == expected, 'Frozen input mismatch: '+name)
    require((ROOT/'evidence/exact/check-results.json').read_bytes() ==
            (ROOT/'evidence/exact/check-results-optimized.json').read_bytes(), 'Exact receipts differ')
    manuscript = read_json('evidence/manuscript/receipt.json')
    require(manuscript['status'] == 'PASS', 'Manuscript build failed')
    for name, expected in manuscript['manuscript_sha256'].items():
        require(digest(ROOT/'paper'/name) == expected, 'Manuscript receipt mismatch: '+name)
    pdf_hash = digest(ROOT/'paper/rare_misses.pdf')
    require(pdf_hash == manuscript['pdf_sha256'], 'Packaged PDF differs from the built PDF')
    qa = read_json('evidence/manuscript/qa-review.json')
    require(qa['status'] == 'PASS' and qa['pdf_sha256'] == pdf_hash, 'PDF visual review is stale')
    require(qa['pages_reviewed'] == list(range(1, manuscript['pages']+1)), 'Incomplete PDF visual review')
    subprocess.run([sys.executable, str(ROOT/'quantitative.py'), 'verify',
                    str(ROOT/'fixtures/quantitative-reset.json'),
                    str(ROOT/'evidence/quantitative/reset-certificate.json')],
                   check=True, capture_output=True, text=True)
    print(json.dumps({'status': 'PASS', 'tracked_files': len(names), 'tracked_bytes': total,
                      'local_links_checked': links, 'proof_declarations': proof['theorems_checked'],
                      'pdf_pages': manuscript['pages'], 'quantitative_certificate': 'PASS'}, indent=2))


if __name__ == '__main__':
    main()
