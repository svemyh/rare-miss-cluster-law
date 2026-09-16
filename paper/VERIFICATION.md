# Packaged manuscript verification

Only the proof-status disclosures changed for this package. The mathematical exposition and bibliography are unchanged from the internally reviewed draft. The original `THEOREM.md` and `verify.py` hashes remain required by the build.

The source is rebuilt with `python3 paper/build.py`, checking references/layout diagnostics, expected extracted text, rendered-page presence, frozen inputs and normal/optimized exact-check agreement. All pages of the committed PDF are visually inspected. Its identity and page list are in `evidence/manuscript/qa-review.json`; mechanical checks are in `evidence/manuscript/receipt.json`.

The main theorem's separate kernel audit is in `evidence/lean/`. PDF compilation and finite checks do not establish the general theorem or novelty. Human specialist review and a fresh independent review of the typeset paper remain pending.
