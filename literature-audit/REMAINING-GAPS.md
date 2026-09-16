# Primary-source follow-up for the publication revision

Checked September 16, 2026 UTC. One named source-access gap is closed at theorem-section depth. Four exact journal/conference targets remain unclosed. Two relevant earlier preprints were read separately; their identity with later journal versions has not been established. No human novelty assessment has been received.

## Current ledger

| Exact target | New evidence | Status |
|---|---|---|
| Kozyakin, Kuznetsov, Chebotarev 2019, DOI 10.1134/S0005117919060018 | Actual 27-page published PDF obtained from the public Drive folder linked by the author. Relevant sections and statements read. | Primary-text gap closed for the comparison below |
| Zhao 2019, DOI 10.1016/j.jmaa.2019.01.065 | Publisher metadata retrieved. FULL-view API request returned 401; direct Aside visit reached a human-verification page. A distinct 2014 preprint was read. | Exact 2019 text remains unclosed |
| Hertneck, Linsenmayer, Allgower 2021, DOI 10.1016/j.automatica.2021.109868 | Publisher/OpenAlex metadata retrieved. The 2020 IFAC precursor was obtained and read at its main stability theorem and proof. | Exact 2021 text remains unclosed |
| Gurvits, Samorodnitsky 2005, DOI 10.1109/CDC.2005.1582513 | Semantic Scholar still returns no open PDF. The old CCNY author host did not resolve. Earlier verified attribution remains available. | Original remains unclosed |
| Vrabel 2026, DOI 10.1093/imamci/dnag016 | OpenAlex returns a closed-access published location and no repository copy. No new full text obtained. | Remains abstract/metadata-level only |

An HTTP 200 metadata response is not a full-paper read. No account changes, paywall bypass, author messages or paid retrieval were used. The one-shot Aside tab ended with its REPL session; no live CAPTCHA tab is being offered as an available user action.

## Kozyakin–Kuznetsov–Chebotarev 2019

Full title: *Consensus in Asynchronous Multiagent Systems. III. Constructive Stability and Stabilizability*. The PDF prints volume 80, number 6, pages 989–1015, and the exact target DOI. Source discovery: https://kozyakin.github.io/en/publications and the public folder linked from https://kozyakin.github.io/ . Author-hosted file: https://drive.google.com/file/d/1qVA-oNQBlVpdU4O3odVAm652MUwdNF3J/view .

Read §§3.2–3.5, pp. 997–1002, including Theorems 3/4 and Remark 4; also the minimax comparison in §§4.4–4.5. The fixed block-frequency language is recoded as a finite-type Markov constraint. Theorem 4 equates its constrained spectral radius with the periodic counterpart; Remark 4 permits an arbitrary allowed block set. This legitimately includes our fixed-k language. It does not evaluate the first-order coefficient as k changes, bound the relevant cluster gains, or supply the quantitative cutoff error. The minimax statements concern separately selected matrix families and controls. This confirms the fixed-language antecedent already credited, without resolving global novelty.

PDF SHA-256: `49b53bae95311e7cfd39ba05b76dcfae1be10461910e5f0af3fb4e882f78fc30`.

## Zhao's earlier preprint, kept distinct from the 2019 target

*Conditional Ergodic Averages for Asymptotically Additive Potentials*, arXiv:1405.1648v1, 7 May 2014. Source: https://arxiv.org/abs/1405.1648 . Read the constraint definitions, Theorems A–E and the continuity proof of Theorem A, with the variational proof route inspected. It studies prescribed limiting averages and invariant measures. Continuity in an average constraint does not by itself give a first derivative or a hard-window, fixed-budget coefficient for a changing symbolic language. No uniform finite-k error is supplied by the inspected statements. This is a relevant antecedent, but no version link was found establishing it as the complete 2019 article.

PDF SHA-256: `ddf913602eb168be06346ff62384bbfa80bb864222551d40d0333f3be5b687ef`. The publisher labels the 2019 item as open archive in metadata, but the retrieval here still did not yield its text.

## Hertneck's 2020 precursor, kept distinct from 2021

Hertneck, Linsenmayer, Allgower, *Stability Analysis for Nonlinear Weakly Hard Real-Time Control Systems*, arXiv:2005.01345v2, 15 May 2020, an accepted IFAC paper with proofs. Source: https://arxiv.org/abs/2005.01345 . Read its window/graph setup, Theorem 14, Remarks 15/16 and Appendix C. The result combines controller-emulation assumptions and pathwise Lyapunov estimates into a sufficient nonlinear stability condition. It neither identifies the exact constrained matrix growth rate nor evaluates its growing-window coefficient. The 2021 article has a different title; this precursor cannot replace a read of that exact version.

PDF SHA-256: `ad509a230ae265a2dbf7a02e45204ededebef890851bfa31e2b217fee6d6464f`.

## Consequence for the revised paper

Credit the 2019 survey directly for fixed-block spectral/periodic representation, while locating the candidate contribution in uniform packing and the evaluated coefficient. Present the quantitative finite-cutoff result as new to this project, not as a certified first-in-literature result. Keep the four exact source gaps and both human review gates explicit. The older AUDIT.md remains a historical record of the earlier broader search.

Downloaded primary files and access responses are held only in ignored build storage. They are not redistributed in the private Git package. This ledger records identifiers, depth and hashes so a reviewer can obtain legitimate copies independently.
