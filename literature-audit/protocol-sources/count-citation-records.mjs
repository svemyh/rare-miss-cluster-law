// Count saved metadata edges, not primary-paper reads. No network or writes.
import { readFileSync } from 'node:fs';

const sources = [
  ['kozyakin', 'openalex', 'kozyakin-forward-openalex.json'],
  ['gaukler', 'openalex', 'gaukler-forward-openalex.json'],
  ['philippe', 'openalex', 'philippe-forward-openalex.json'],
  ['kozyakin', 's2', 'kozyakin-forward-s2.json'],
  ['philippe', 's2', 'philippe-forward-s2.json'],
];
const records = [];
for (const [seed, database, filename] of sources) {
  const data = JSON.parse(readFileSync(new URL(filename, import.meta.url), 'utf8'));
  const rows = database === 'openalex' ? data.results : data.citations;
  if (!Array.isArray(rows)) throw new Error(`Missing records in ${filename}`);
  for (const row of rows) {
    const ids = [];
    const doi = (row.doi ?? row.externalIds?.DOI)?.replace(/^https?:\/\/(?:dx\.)?doi\.org\//i, '').toLowerCase();
    if (doi) ids.push(`doi:${doi}`);
    const arxiv = row.externalIds?.ArXiv ?? doi?.match(/^10\.48550\/arxiv\.(.+)$/)?.[1];
    if (arxiv) ids.push(`arxiv:${arxiv.replace(/v\d+$/i, '').toLowerCase()}`);
    const openalex = row.id?.match(/openalex\.org\/W(\d+)/)?.[1] ?? row.externalIds?.MAG;
    if (openalex) ids.push(`mag:${openalex}`);
    if (row.paperId) ids.push(`s2:${row.paperId}`);
    const title = row.title?.normalize('NFKC').toLowerCase().replace(/[^\p{L}\p{N}]/gu, '');
    if (title) ids.push(`title:${title}`);
    records.push({ seed, database, ids });
  }
}
function count(rows, includeTitles) {
  const parents = rows.map((_, index) => index);
  const seen = new Map();
  const root = index => parents[index] === index ? index : (parents[index] = root(parents[index]));
  rows.forEach((row, index) => {
    for (const id of row.ids) {
      if (!includeTitles && id.startsWith('title:')) continue;
      if (seen.has(id)) parents[root(index)] = root(seen.get(id));
      else seen.set(id, index);
    }
  });
  return new Set(rows.map((_, index) => root(index))).size;
}
function summarize(rows) {
  return { rawEdges: rows.length, identifierOnly: count(rows, false), identifierOrNormalizedTitle: count(rows, true) };
}
console.log(JSON.stringify({
  method: 'Connected components sharing exact normalized DOI, arXiv ID, OpenAlex/MAG ID, S2 ID; optional exact NFKC/lowercase/alphanumeric title. No fuzzy matching. Not a full-date-filtered union.',
  seeds: Object.fromEntries(['kozyakin', 'gaukler', 'philippe'].map(seed => [seed, summarize(records.filter(row => row.seed === seed))])),
  all: summarize(records),
}, null, 2));
