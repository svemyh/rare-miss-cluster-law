# External Perron proof provenance

Source repository: https://github.com/mkaxiomatic-ai/HNBM
Commit: 58b321e9c9b86448e4fdd897a428c8cef7297f5e
Directories copied: PF/ and MCMC/{Core,TotalVariation,Convergence}.lean

The copied proof-file headers identify Matteo Cipollina, copyright 2025, and Apache 2.0 licensing. Those headers are retained. The source repository also supplies a root MIT-style LICENSE.md, copied here as HNBM-LICENSE.md. Both source notices are preserved; no authorship or relicensing claim is made for the imported code. The standard Apache 2.0 text is included as APACHE-2.0 from the pinned mathlib distribution.

All 20 copied files were compared byte-for-byte with the clean checkout at the pinned commit. Their hashes are in UPSTREAM-HASHES.json and are checked by check.py. The dependency closures of the final imported bridge and main theorem have now passed Lean trust-zero checking with only propext, Classical.choice and Quot.sound. Copying or a README claim was not used as proof evidence.
