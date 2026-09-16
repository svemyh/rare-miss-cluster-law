# Publication and quantitative-bounds revision

Revision 2. Verified September 16, 2026 UTC. Coordinator: the current Codex task.
Repository: svemyh/rare-miss-cluster-law, branch codex/publication-revision.
Baseline commit: ca44d18551fe18b0248dc5c95b0038a78d5c2dfc.

## Objective and stopping conditions

Revise the paper around uniform cluster packing and its Lean formalization; revisit the strongest remaining primary-literature gaps; prepare separate mathematical and formalization specialist review; and investigate explicit certified two-sided finite-window bounds.

Local completion requires a rebuilt/visually checked manuscript, a theorem-to-Lean correspondence audit, recorded primary-source comparisons, and either a proved quantitative statement with appropriately scoped checks or a precise obstruction. Actual human review is a separate gate and cannot be supplied by coordinator self-review or additional automated checks.

## Authority

The user requested all three workstreams. Work is local and on the private repository. Preserve the original theorem and verifier hashes and the existing checked main theorem. No public release, journal submission, reviewer contact, collaborator invitation, paid worker restart, or spending-limit change is authorized. Human reviewer selection and permission to share are required before outreach. No new cloud or recurring jobs.

## Workstreams

| Workstream | Owner | State | Acceptance evidence / next step |
|---|---|---|---|
| Quantitative theorem | Coordinator | complete in stated scope | Genuine cutoff and finite-window/error/accuracy implications are checked; automatic minorization and big-O corollary have classical proofs with their boundary explicit |
| Formal correspondence and extension | Coordinator | local check complete; specialist review pending | 201 declarations pass trust zero, five invalid controls rejected; separate quantitative consumer passes; coordinator semantic audit recorded |
| Remaining primary literature | Coordinator | partially resolved | Kozyakin 2019 exact text gap closed; two earlier preprints inspected; four exact targets remain unclosed in REMAINING-GAPS.md |
| Publication-focused manuscript | Coordinator | complete locally | Eleven-page revision centers packing, adds the quantitative theorem and formalization map, preserves explanatory examples, and passes build/all-page visual checks |
| Mathematical and formalization specialists | Human reviewers, not assigned | awaiting owner selection and sharing scope | Separate briefs and candidate list prepared; needs-human issue rare-miss-specialist-review delivered once at normal priority; no assessment received or contact made |

## Established quantitative route

Under a certified relative tail (1-e)P <= B^g <= (1+e)P for g>=q, 0<=e<1, clamp long gaps to B^q. The finite attained maximum satisfies A_m(q)<=M_m<=((1+e)/(1-e))^(m-1) A_m(q), and an attaining word has length at most m+(m-1)q. For k>=m(q+1), its period-k extension gives a quantitative lower bound; the uniform packing theorem supplies the upper bound. These implications and the all-later-windows accuracy certificate are now kernel-checked. The explicit automatic tail and O(log(k)/k) corollary are classically derived, not separately Lean-formalized.

## Remaining gate

Local revision work is complete, but publication validation is not. Obtain authorized human mathematical and formalization assessments and close or qualify the four exact-source gaps. No publication novelty, acceptance, human endorsement or submission is claimed. Do not restart paid workers or contact proposed reviewers without the owner's explicit direction.

## Record

Observations, failed routes, proof boundaries and source-access results are recorded in REVISION_JOURNAL.md. The original 175-declaration main-theorem receipt remains the baseline evidence; new claims require their own checked evidence. Novelty remains provisional.
