"""Deterministic rational checks, not a proof assistant or novelty oracle."""

from fractions import Fraction as Q
from hashlib import sha256
from itertools import product
from pathlib import Path
import argparse
import json


class CheckFailure(Exception):
    pass


def check(condition, message):
    if not condition:
        raise CheckFailure(message)


def identity(n):
    return tuple(tuple(Q(i == j) for j in range(n)) for i in range(n))


def multiply(a, b):
    n = len(a)
    return tuple(tuple(sum((a[i][s] * b[s][j] for s in range(n)), Q(0))
                       for j in range(n)) for i in range(n))


def power(a, exponent):
    result = identity(len(a))
    while exponent:
        if exponent % 2:
            result = multiply(result, a)
        a = multiply(a, a)
        exponent //= 2
    return result


def perron_weight(a):
    # All fixtures have r=ones and ell=ones/n.
    return sum((sum(row) for row in a), Q(0)) / len(a)


def cycle_fixture(n, theta):
    p = tuple(tuple(Q(1, n) for _ in range(n)) for _ in range(n))
    r = tuple(tuple(Q(j == (i + 1) % n) for j in range(n)) for i in range(n))
    b = tuple(tuple(theta * r[i][j] + (1-theta) * p[i][j]
                    for j in range(n)) for i in range(n))
    return b, p, r


def finite_cluster_bounds(b, e, p, theta, budget, cutoff):
    factors = [power(b, g) for g in range(cutoff)] + [p]
    levels = []
    for misses in range(1, budget + 1):
        best, best_gaps = Q(0), None
        for gaps in product(range(cutoff + 1), repeat=misses-1):
            matrix = e
            for gap in gaps:
                matrix = multiply(multiply(matrix, factors[gap]), e)
            weight = perron_weight(matrix)
            if weight > best:
                best, best_gaps = weight, gaps
        levels.append({
            'misses': misses, 'max_weight': best,
            'gaps': [('P' if g == cutoff else g) for g in best_gaps],
        })
    lower = max(Q(1), *(row['max_weight'] for row in levels))
    epsilon = (len(b)-1) * theta**cutoff
    upper = (1+epsilon)**(budget-1) * lower
    return {'cutoff': cutoff, 'tail_epsilon': epsilon, 'lower': lower,
            'upper': upper, 'levels': levels}


def prefix_allowed(word, budget, window):
    zeros = [i for i, bit in enumerate(word) if bit == 0]
    return all(zeros[i+budget] - zeros[i] >= window
               for i in range(len(zeros)-budget))


def padded_window_oracle(word, budget, window):
    # Prefixes are extended with successes. Even short prefixes are checked.
    return all(sum(bit == 0 for bit in word[start:start+window]) <= budget
               for start in range(len(word)))


def cyclic_allowed(word, budget, window):
    return all(sum(word[(start+j) % len(word)] == 0 for j in range(window))
               <= budget for start in range(len(word)))


def cluster_data(word, q):
    groups = []
    for index, bit in enumerate(word):
        if bit:
            continue
        if not groups or index-groups[-1][-1]-1 >= q:
            groups.append([index])
        else:
            groups[-1].append(index)
    return groups


def cluster_matrix(indices, b, e):
    matrix = e
    for left, right in zip(indices, indices[1:]):
        matrix = multiply(multiply(matrix, power(b, right-left-1)), e)
    return matrix


def finite_word_checks(b, e, theta, budget, window, length, q, coefficient_upper):
    check(budget*q+1 <= window, 'cluster width prerequisite')
    bin_size = window-budget*q
    epsilon = (len(b)-1)*theta**q
    count = 0
    for word in product((0, 1), repeat=length):
        allowed = prefix_allowed(word, budget, window)
        check(allowed == padded_window_oracle(word, budget, window),
              'independent protocol validators disagree')
        if not allowed:
            continue
        count += 1
        clusters = cluster_data(word, q)
        bins = {}
        for indices in clusters:
            check(len(indices) <= budget, 'cluster exceeds miss budget')
            index = indices[0] // bin_size
            bins.setdefault(index, []).append(indices)
        for groups in bins.values():
            check(sum(map(len, groups)) <= budget, 'bin packing failure')
            gain = Q(1)
            for indices in groups:
                gain *= perron_weight(cluster_matrix(indices, b, e))
            check(gain <= coefficient_upper, 'cluster bin gain exceeds enclosure')
        matrix = identity(len(b))
        for bit in word:
            matrix = multiply(b if bit else e, matrix)
        misses = word.count(0)
        upper = len(b)*(1+epsilon)**misses * coefficient_upper**((length+bin_size-1)//bin_size)
        check(max(map(sum, matrix)) <= upper, 'uniform finite word bound fails')
    return {'length': length, 'window': window, 'budget': budget,
            'q': q, 'allowed_words_checked': count,
            'all_binary_words_classified': 2**length}


def spectral_bracket(matrix, iterations=12):
    vector = tuple(Q(1) for _ in matrix)
    lower, upper = Q(0), None
    for _ in range(iterations):
        image = tuple(sum((a*x for a, x in zip(row, vector)), Q(0)) for row in matrix)
        ratios = tuple(y/x for y, x in zip(image, vector))
        lower = max(lower, min(ratios))
        upper = max(ratios) if upper is None else min(upper, max(ratios))
        check(lower <= upper, 'invalid Collatz bracket')
        scale = max(image)
        vector = tuple(value/scale for value in image)
    return {'lower': lower, 'upper': upper, 'iterations': iterations}


def periodic_checks(b, e, budget, gap):
    rows = []
    for window in (8, 16, 32):
        word = (0,) + (1,)*gap + (0,) + (1,)*(window-gap-2)
        check(cyclic_allowed(word, budget, window), 'periodic witness violates protocol')
        matrix = multiply(multiply(multiply(power(b, window-2-gap), e), power(b, gap)), e)
        rows.append({'window': window, 'misses_per_period': 2, 'gap': gap,
                     'normalized_period_spectral_radius': spectral_bracket(matrix)})
    return rows


def reset_finite_window_checks():
    # Nonuniform Perron weights; separate from the doubly-stochastic fixtures.
    ell = (Q(99,100), Q(1,100))
    e = ((Q(1,10),Q(1,10)), (Q(20),Q(1,10)))
    weights = [sum((ell[i]*sum(row) for i,row in enumerate(power(e,j))), Q(0))
               for j in (1,2,3)]
    check(weights == [Q(399,1000),Q(10349,5000),Q(120797,100000)],
          'independent reset example arithmetic')
    e1,e2,e3 = weights
    check(e1 < 1 < e2 and e3 < e2, 'reset theorem prerequisites')
    cases = 0
    length = 12
    for window in range(4,9):
        period = (0,0)+(1,)*(window-3)
        check(cyclic_allowed(period,3,window), 'shorter periodic witness inadmissible')
        for word in product((0,1), repeat=length):
            if not prefix_allowed(word,3,window):
                continue
            cases += 1
            runs = cluster_data(word,1)
            reduced = [1]*length
            gain = Q(1)
            pairs = []
            for run in runs:
                check(len(run) <= 3, 'reset run longer than three')
                gain *= weights[len(run)-1]
                if len(run) >= 2:
                    reduced[run[0]] = reduced[run[1]] = 0
                    pairs.append(run[0])
            check(prefix_allowed(reduced,3,window), 'removing misses broke admissibility')
            check(gain <= e2**len(pairs), 'run replacement decreased Perron weight')
            check(all(b-a >= window-1 for a,b in zip(pairs,pairs[1:])),
                  'pair packing violated')
            check((len(pairs)-1)*(window-1) <= length, 'pair count bound violated')
    nominal = Q(9,10)
    first_stable = next(k for k in range(4,100) if nominal**(k-1)*e2 < 1)
    check(first_stable == 8, 'exact stability threshold')
    return {'E':e, 'ell':ell, 'e1':e1, 'e2':e2, 'e3':e3,
            'admissible_run_replacement_cases':cases, 'prefix_length':length,
            'windows':list(range(4,9)), 'nominal_lambda':nominal,
            'first_exponentially_stable_window':first_stable,
            'threshold_inequality_at_7':nominal**6*e2,
            'threshold_inequality_at_8':nominal**7*e2}


def run():
    b2, p2, r2 = cycle_fixture(2, Q(1,2))
    e2 = ((Q(1,5), Q(3,2)), (Q(1,2), Q(1,5)))
    b3, p3, r3 = cycle_fixture(3, Q(1,2))
    v, w = (3, 1, 1), (1, 3, 1)
    e3 = tuple(tuple(Q(x*y,5) for y in w) for x in v)
    b5, p5, r5 = cycle_fixture(5, Q(0))
    e5 = tuple(tuple(Q(12,5) if (i,j) in ((0,1), (1,2)) else Q(1,200)
                     for j in range(5)) for i in range(5))
    fixtures = [(b2,e2,p2,r2,Q(1,2)), (b3,e3,p3,r3,Q(1,2)), (b5,e5,p5,r5,Q(0))]
    for b,e,p,r,theta in fixtures:
        n = len(b)
        check(all(value > 0 for row in b+e for value in row), 'positive fixture required')
        check(all(sum(row) == 1 for row in b), 'right Perron vector')
        check(all(sum(row[j] for row in b) == 1 for j in range(n)), 'left Perron vector')
        for g in range(17):
            bg, rg = power(b,g), power(r,g)
            expected = tuple(tuple(p[i][j]+theta**g*(rg[i][j]-p[i][j])
                                   for j in range(n)) for i in range(n))
            check(bg == expected, 'cycle Perron identity')
    arbitrary_gap_checks = []
    for target in range(1,7):
        n = target+1
        bg,pg,_ = cycle_fixture(n,Q(1,2))
        vg = tuple(1+n*(i == 0) for i in range(n))
        wg = tuple(1+n*(i == 1) for i in range(n))
        eg = tuple(tuple(Q(x*y,2*n) for y in wg) for x in vg)
        check(perron_weight(eg) == 2, 'arbitrary gap singleton gain')
        check(perron_weight(multiply(multiply(eg,power(bg,target)),eg))
              == 4+Q(n-1,2**target), 'arbitrary gap peak')
        for gap in range(3*n):
            actual = perron_weight(multiply(multiply(eg,power(bg,gap)),eg))
            expected = 4+Q(n*(gap % n == target)-1,2**gap)
            check(actual == expected, 'arbitrary gap residue identity')
            check(actual <= 4+Q(n-1,2**target), 'arbitrary gap maximality check')
        arbitrary_gap_checks.append({'target_gap':target,'dimension':n,
                                     'peak':4+Q(n-1,2**target),'gaps_checked':3*n})
    planar = [perron_weight(multiply(multiply(e2,power(b2,g)),e2)) for g in range(32)]
    check(planar[0] == Q(119,100) and planar[1] == Q(313,200), 'historical example')
    check(all(value == Q(36,25)-Q(1,4)*Q(-1,2)**g for g,value in enumerate(planar)),
          'historical pair sequence')
    three = [perron_weight(multiply(multiply(e3,power(b3,g)),e3)) for g in range(32)]
    check(three[:3] == [Q(7,3), Q(23,9), Q(3)], 'three-state counterexample values')
    check(three[2] > max(Q(1), perron_weight(e3)**2, three[0], three[1]),
          'three-state example must refute planar candidate list')
    # The all-gap conclusion additionally uses the period-three decomposition in EXAMPLES.md.
    bounds2 = finite_cluster_bounds(b2,e2,p2,Q(1,2),2,8)
    bounds3 = finite_cluster_bounds(b3,e3,p3,Q(1,2),2,8)
    bounds5 = finite_cluster_bounds(b5,e5,p5,Q(0),3,1)
    a,b,c = (perron_weight(power(e5,j)) for j in (1,2,3))
    check(a < 1 < b and c < b, 'unused-budget example prerequisites')
    check(bounds5['lower'] == bounds5['upper'] == b, 'exact rank-one-reset coefficient')
    check(bounds5['levels'][2]['max_weight'] < b, 'three misses must be strictly worse')
    density_trap = (0,0,0)+(1,)*9
    check(Q(density_trap.count(0),len(density_trap)) == Q(2,8), 'density trap construction')
    check(not prefix_allowed(density_trap,2,8), 'average density must not replace protocol')
    negative_controls = []
    for name, predicate in (
        ('corrupted_planar_coefficient', planar[1] <= planar[0]),
        ('planar_formula_in_dimension_three', three[2] <= max(Q(1),perron_weight(e3)**2,three[0],three[1])),
        ('density_only_protocol', prefix_allowed(density_trap,2,8)),
    ):
        try:
            check(predicate, name)
        except CheckFailure:
            negative_controls.append(name)
        else:
            raise CheckFailure('negative control was accepted: '+name)
    word_checks = [
        finite_word_checks(b2,e2,Q(1,2),2,7,10,2,bounds2['upper']),
        finite_word_checks(b3,e3,Q(1,2),2,7,10,2,bounds3['upper']),
        finite_word_checks(b5,e5,Q(0),3,9,10,2,bounds5['upper']),
    ]
    return {
        'status': 'PASS', 'arithmetic': 'exact rational',
        'scope': 'finite arithmetic/protocol/enclosure checks; not a formal proof of THEOREM.md',
        'planar': {'coefficient': Q(313,200), 'finite_search': bounds2},
        'three_state': {'a_squared': perron_weight(e3)**2, 'b0':three[0], 'b1':three[1],
                        'b2':three[2], 'finite_search':bounds3},
        'unused_budget': {'e1':a, 'e2':b, 'e3':c, 'finite_search':bounds5},
        'negative_controls_rejected': negative_controls, 'finite_word_checks':word_checks,
        'arbitrary_gap_family': arbitrary_gap_checks,
        'reset_finite_window': reset_finite_window_checks(),
        'periodic_brackets': {'planar_gap1':periodic_checks(b2,e2,2,1),
                              'three_state_gap2':periodic_checks(b3,e3,2,2)},
        'matrices': [{'B':b,'E':e,'P':p,'theta':theta} for b,e,p,_,theta in fixtures],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, help='Write generated JSON evidence to this path')
    args = parser.parse_args()
    result = run()
    root = Path(__file__).resolve().parent
    result['inputs_sha256'] = {name: sha256((root/name).read_bytes()).hexdigest()
                               for name in ('verify.py','THEOREM.md')}
    encoded = json.dumps(result, default=str, indent=2, sort_keys=True)
    if args.output:
        args.output.write_text(encoded+'\n')
    print(encoded)


if __name__ == '__main__':
    main()
