"""Build and mechanically check the local working paper; no paid services."""

from pathlib import Path
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import zipfile


ROOT = Path(__file__).resolve().parent
BUILD = ROOT / 'build'
FROZEN = {
    'THEOREM.md': '4acd0ef06ece65c0471d70b727b7dc152f73b469f7aedae5d79a4ca285a10e34',
    'verify.py': 'a27bd934b0546e89c8a660beec11f6a19fed10e86670d06689b89b4841c7332e',
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def evidence_root():
    for path in (ROOT.parent, ROOT / 'evidence'):
        if all((path / name).is_file() for name in FROZEN):
            return path
    raise RuntimeError('Expected the frozen theorem and checker beside the project or in evidence/')


def check_frozen():
    base = evidence_root()
    for name, expected in FROZEN.items():
        require(digest(base / name) == expected, f'Frozen input changed: {name}')
    return base


def executable(name):
    result = shutil.which(name)
    require(result is not None, f'Required executable is not on PATH: {name}')
    return result


def run(command, log_name, timeout=300):
    with (BUILD / log_name).open('w') as log:
        result = subprocess.run(command, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT,
                                timeout=timeout, check=False)
    require(result.returncode == 0, f'Command failed; inspect build/{log_name}')


def build():
    base = check_frozen()
    BUILD.mkdir(exist_ok=True)
    tectonic = executable('tectonic')
    run([tectonic, '--untrusted', '--keep-logs', '--keep-intermediates',
         '--outdir', str(BUILD), str(ROOT / 'rare_misses.tex')], 'engine-output.txt')
    pdf = BUILD / 'rare_misses.pdf'
    require(pdf.is_file() and pdf.read_bytes().startswith(b'%PDF-'), 'No usable PDF produced')
    tex_log = (BUILD / 'rare_misses.log').read_text(errors='replace')
    bad_log = re.findall(
        r'^.*(?:Overfull \[hv]box|undefined references|Citation .+ undefined|Reference .+ undefined|LaTeX Error).*$',
        tex_log, re.MULTILINE | re.IGNORECASE)
    require(not bad_log, 'Unresolved TeX issues: ' + '; '.join(bad_log))
    text_path = BUILD / 'paper-text.txt'
    run([executable('pdftotext'), '-layout', str(pdf), str(text_path)], 'extract-output.txt')
    extracted = text_path.read_text()
    require('??' not in extracted, 'Unresolved reference visible in PDF text')
    for phrase in ('Rare-miss growth', 'Window packing', 'Matching periodic',
                   'Publication', 'References'):
        # Case-insensitive to accommodate section typography.
        require(phrase.lower() in extracted.lower(), f'Missing expected PDF section: {phrase}')
    info = subprocess.run([executable('pdfinfo'), str(pdf)], check=True,
                          capture_output=True, text=True).stdout
    (BUILD / 'pdfinfo.txt').write_text(info)
    match = re.search(r'^Pages:\s+(\d+)$', info, re.MULTILINE)
    require(match is not None, 'Could not determine PDF page count')
    pages = int(match.group(1))
    require(1 <= pages <= 14, f'Unexpected paper length: {pages} pages')
    qa = BUILD / 'qa'
    qa.mkdir(exist_ok=True)
    run([executable('pdftoppm'), '-r', '100', '-png', str(pdf), str(qa / 'page')],
        'render-output.txt')
    # Resolve every expected page explicitly; do not treat stale extra images as new pages.
    for index in range(1, pages+1):
        candidates = [qa / f'page-{index}.png', qa / f'page-{index:02d}.png',
                      qa / f'page-{index:03d}.png']
        require(any(path.is_file() for path in candidates), f'Missing rendered page {index}')
    python = executable('python3')
    run([python, str(base / 'verify.py'), '--output', str(BUILD / 'check-results.json')],
        'arithmetic-output.txt')
    run([python, '-I', '-O', str(base / 'verify.py'), '--output',
         str(BUILD / 'check-results-optimized.json')], 'arithmetic-optimized-output.txt')
    normal = (BUILD / 'check-results.json').read_bytes()
    require(normal == (BUILD / 'check-results-optimized.json').read_bytes(),
            'Normal and optimized arithmetic receipts differ')
    checks = json.loads(normal)
    require(checks['status'] == 'PASS', 'Exact checks did not pass')
    require(checks['inputs_sha256'] == FROZEN, 'Exact-check input identities disagree')
    word_cases = sum(row['allowed_words_checked'] for row in checks['finite_word_checks'])
    reset_cases = checks['reset_finite_window']['admissible_run_replacement_cases']
    require((word_cases, reset_cases) == (408, 7767), 'Unexpected finite-case coverage')
    require(len(checks['negative_controls_rejected']) == 3, 'Missing negative controls')
    version = subprocess.run([tectonic, '--version'], check=True, capture_output=True, text=True).stdout.strip()
    receipt = {
        'status': 'PASS',
        'scope': 'Build, text/reference checks, rendered-page presence and frozen finite arithmetic; not a formal proof',
        'tectonic': version, 'pages': pages, 'overfull_or_unresolved_reference_messages': bad_log,
        'finite_word_cases': word_cases, 'reset_cases': reset_cases,
        'negative_controls_rejected': checks['negative_controls_rejected'],
        'normal_optimized_receipts_identical': True, 'frozen_inputs_sha256': FROZEN,
        'manuscript_sha256': {name: digest(ROOT / name) for name in
                              ('rare_misses.tex', 'references.bib', 'build.py')},
        'pdf_sha256': digest(pdf),
        'manual_visual_review': 'Separate record required in VERIFICATION.md and build/qa-review.json',
        'fresh_context_reader_review': 'Not performed in this stage',
        'external_specialist_review': 'Not performed',
        'publication_novelty': 'Provisional',
    }
    (BUILD / 'receipt.json').write_text(json.dumps(receipt, indent=2, sort_keys=True)+'\n')
    print(json.dumps(receipt, indent=2, sort_keys=True))


def package():
    base = check_frozen()
    receipt = json.loads((BUILD / 'receipt.json').read_text())
    require(receipt['status'] == 'PASS', 'A successful build receipt is required')
    for name, expected in receipt['manuscript_sha256'].items():
        require(digest(ROOT / name) == expected, f'Rebuild before packaging changed source: {name}')
    require(digest(BUILD / 'rare_misses.pdf') == receipt['pdf_sha256'], 'PDF changed after build')
    qa = json.loads((BUILD / 'qa-review.json').read_text())
    require(qa.get('status') == 'PASS' and qa.get('pdf_sha256') == receipt['pdf_sha256'],
            'Current PDF requires a recorded visual review')
    require(qa.get('pages_reviewed') == list(range(1, receipt['pages']+1)),
            'Visual record must cover every current PDF page')
    files = [(ROOT / name, name) for name in (
        'rare_misses.tex', 'references.bib', 'build.py', 'README.md',
        'REVIEWER-BRIEF.md', 'SOURCE-ACCESS.md', 'VERIFICATION.md',
        'build/rare_misses.pdf', 'build/receipt.json', 'build/qa-review.json')]
    files.extend((base / name, 'evidence/'+name) for name in FROZEN)
    files.extend((BUILD / name, 'evidence/'+name) for name in
                 ('check-results.json','check-results-optimized.json'))
    audit_dir = base / 'literature-audit'
    for name in ('AUDIT.md','antecedents.md','protocol-forward.md','rare-defects.md'):
        path = audit_dir / name
        require(path.is_file(), f'Missing selected review evidence: {name}')
        files.append((path, 'evidence/literature-audit/'+name))
    for source, _ in files:
        require(source.is_file(), f'Missing packet input: {source.name}')
    archive = ROOT / 'rare-misses-review-packet.zip'
    with zipfile.ZipFile(archive, 'w', compression=zipfile.ZIP_DEFLATED) as packet:
        for source, relative in files:
            packet.write(source, 'rare-misses-review/'+relative)
    with zipfile.ZipFile(archive) as packet:
        require(packet.testzip() is None, 'Archive integrity failure')
        require(len(packet.namelist()) == len(files), 'Packet member mismatch')
    print(json.dumps({'archive': archive.name, 'files': len(files),
                      'sha256': digest(archive), 'bytes': archive.stat().st_size}, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--package-only', action='store_true',
                        help='Package already-built and visually reviewed selected artifacts')
    args = parser.parse_args()
    package() if args.package_only else build()
