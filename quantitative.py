"""Exact rational certificates for the finite-window theorem in QUANTITATIVE.md."""

from dataclasses import dataclass
from fractions import Fraction as F
import argparse
import hashlib
import itertools
import json
from pathlib import Path

MAX_CANDIDATES = 100_000
MAX_POWER_BITS = 1_000_000


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational(value):
    require(isinstance(value, (str, int)) and not isinstance(value, bool),
            'Rational entries must be strings or integers, never floats or booleans')
    return F(value)


def natural(value, name, minimum=1):
    require(isinstance(value, int) and not isinstance(value, bool) and value >= minimum,
            name+' is outside its integer domain')
    return value


def identity(d):
    return tuple(tuple(F(i == j) for j in range(d)) for i in range(d))


def multiply(A, B):
    return tuple(tuple(sum((A[i][s]*B[s][j] for s in range(len(B))), F(0))
                       for j in range(len(B[0]))) for i in range(len(A)))


def power(A, exponent):
    result = identity(len(A))
    while exponent:
        if exponent & 1:
            result = multiply(result, A)
        exponent //= 2
        if exponent:
            A = multiply(A, A)
    return result


def act(A, r):
    return tuple(sum((entry*x for entry, x in zip(row, r)), F(0)) for row in A)


def left_act(l, A):
    return tuple(sum((l[i]*A[i][j] for i in range(len(l))), F(0)) for j in range(len(l)))


def gain(l, A, r):
    return sum((a*b for a, b in zip(l, act(A, r))), F(0))


@dataclass(frozen=True)
class Model:
    B: tuple
    E: tuple
    right: tuple
    left: tuple
    lam: F

    @classmethod
    def parse(cls, data):
        B = tuple(tuple(rational(x) for x in row) for row in data['normalized_success'])
        E = tuple(tuple(rational(x) for x in row) for row in data['normalized_miss'])
        r, l = tuple(map(rational, data['right'])), tuple(map(rational, data['left']))
        d = len(B)
        require(1 <= d <= 64, 'The exact tool supports dimensions 1 through 64')
        require(len(E) == len(r) == len(l) == d and all(len(row) == d for row in B+E),
                'Matrix/frame dimensions disagree')
        require(all(x > 0 for row in B+E for x in row) and all(x > 0 for x in r+l),
                'Strict positivity is required')
        require(act(B, r) == r and left_act(l, B) == l, 'The frame is not fixed by B')
        require(sum((a*b for a, b in zip(l, r)), F(0)) == 1, 'Frame pairing must equal one')
        lam = rational(data['lambda'])
        require(lam > 0, 'The nominal scale must be positive')
        return cls(B, E, r, l, lam)


def tail_data(model):
    """Finite identities implying the all-powers tail bound, not sampled powers."""
    B, r, l = model.B, model.right, model.left
    d = len(B)
    P = tuple(tuple(r[i]*l[j] for j in range(d)) for i in range(d))
    pi_min = min(a*b for a, b in zip(l, r))
    require(multiply(P, P) == P, 'Projector identity failed')
    if B == P:
        return {'kind': 'exact_reset', 'theta': F(0), 'pi_min': pi_min, 'alpha': F(1)}
    eta = min(B[i][j]/P[i][j] for i in range(d) for j in range(d))
    require(0 < eta <= 1, 'Invalid positive minorization')
    alpha, theta = eta/2, 1-eta/2
    Q = tuple(tuple((B[i][j]-alpha*P[i][j])/theta for j in range(d)) for i in range(d))
    require(all(x >= 0 for row in Q for x in row), 'Residual matrix is not nonnegative')
    require(act(Q, r) == r and left_act(l, Q) == l, 'Residual frame identities failed')
    require(multiply(Q, P) == P and multiply(P, Q) == P, 'Absorption identities failed')
    require(all(B[i][j] == alpha*P[i][j]+theta*Q[i][j] for i in range(d) for j in range(d)),
            'Minorization decomposition failed')
    return {'kind': 'minorization', 'theta': theta, 'pi_min': pi_min, 'alpha': alpha}


def epsilon(tail, q):
    natural(q, 'cutoff')
    if tail['kind'] == 'exact_reset':
        return F(0)
    theta = tail['theta']
    require(q*max(theta.numerator.bit_length(), theta.denominator.bit_length()) <= MAX_POWER_BITS,
            'Tail calculation exceeds the exact arithmetic resource limit')
    return theta**q/tail['pi_min']


def cutoff_for_accuracy(tail, tolerance):
    require(tolerance > 0, 'Tail tolerance must be positive')
    upper = 1
    while epsilon(tail, upper) > tolerance:
        upper *= 2
    lower = 1
    while lower < upper:
        middle = (lower+upper)//2
        if epsilon(tail, middle) <= tolerance:
            upper = middle
        else:
            lower = middle+1
    return lower


def cutoff(model, m, q):
    natural(m, 'budget')
    natural(q, 'cutoff')
    candidate_count, term = 1, 1
    for _ in range(m):
        candidate_count += term
        require(candidate_count <= MAX_CANDIDATES, 'Finite search exceeds MAX_CANDIDATES')
        term *= q+1
    powers = {0: identity(len(model.B))}
    best, witness, best_matrix = F(1), {'misses': 0, 'gaps_matrix_order': [], 'length': 0}, powers[0]
    visited = 1
    for j in range(1, m+1):
        for gs in itertools.product(range(q+1), repeat=j-1):
            W = model.E
            for g in gs:
                if g not in powers:
                    powers[g] = power(model.B, g)
                W = multiply(multiply(W, powers[g]), model.E)
            value = gain(model.left, W, model.right)
            if value > best:
                best, best_matrix = value, W
                witness = {'misses': j, 'gaps_matrix_order': list(gs), 'length': j+sum(gs)}
            visited += 1
    require(visited == candidate_count, 'Enumeration count disagrees with its finite domain')
    require(witness['length'] <= m+(m-1)*q, 'Witness span exceeds the theorem bound')
    return best, witness, best_matrix, visited


def comparison(expression):
    return {'comparison_to_one': (expression > 1)-(expression < 1),
            'numerator_bits': expression.numerator.bit_length(),
            'denominator_bits': expression.denominator.bit_length()}


def certify(data):
    allowed = {'normalized_success', 'normalized_miss', 'right', 'left', 'lambda',
               'budget', 'cutoff', 'window', 'accuracy'}
    require(set(data) == allowed, 'Input keys must match the documented certificate schema')
    model = Model.parse(data)
    m, q, k = (natural(data[name], name) for name in ('budget', 'cutoff', 'window'))
    delta = rational(data['accuracy'])
    require(delta > 0, 'Accuracy must be positive')
    tail = tail_data(model)
    e = epsilon(tail, q)
    require(e < 1, 'The selected cutoff does not yet certify an error below one')
    require(k >= m*(q+1), 'The window is below the finite-window theorem threshold')
    A, witness, W, candidates = cutoff(model, m, q)
    ratio = (1+e)/(1-e)
    upper_M = A*ratio**(m-1)
    remaining = k-witness['length']
    require(remaining >= q, 'Insufficient certified gap after the witness')
    L = k-m*q
    factors = [(model.lam, k*L), (upper_M, k), (1+e, m*L)]
    bits = sum(exponent*max(base.numerator.bit_length(), base.denominator.bit_length())
               for base, exponent in factors)
    require(bits <= MAX_POWER_BITS, 'Stability comparison exceeds the exact arithmetic resource limit')
    Q = multiply(power(model.B, remaining), W)
    require(all(x >= (1-e)*A*y for x, y in zip(act(Q, model.right), model.right)),
            'Actual period matrix violates its derived cone bound')
    upper_test = model.lam**(k*L)*upper_M**k*(1+e)**(m*L)
    lower_test = model.lam**k*max(F(1), (1-e)*A)
    stable, not_stable = upper_test < 1, lower_test >= 1
    require(not (stable and not_stable), 'Contradictory certificate outcomes')
    c = max(F(1), *(x/y for x, y in zip(act(model.E, model.right), model.right)))
    Hbar = min(m*(c-1), A-1+(m-1)*(ratio-1))
    require(Hbar >= 0, 'The logarithmic coefficient upper bound must be nonnegative')
    tolerance = min(F(1, 2), delta/(6*m))
    q_accuracy = cutoff_for_accuracy(tail, tolerance)
    e_accuracy = epsilon(tail, q_accuracy)
    threshold = 4*m*q_accuracy*Hbar/delta
    ceiling = -(-threshold.numerator // threshold.denominator)
    k0 = max(m*(q_accuracy+1), 2*m*q_accuracy, 1, ceiling)
    require(e_accuracy <= F(1, 2) and 6*m*e_accuracy <= delta and
            4*m*q_accuracy*Hbar <= k0*delta, 'Accuracy-threshold certificate failed')
    return {
        'schema': 'rare-miss-quantitative-v1',
        'input_sha256': hashlib.sha256(json.dumps(data, sort_keys=True, separators=(',', ':')).encode()).hexdigest(),
        'implementation_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'arithmetic': 'exact rational', 'dimension': len(model.B), 'budget': m, 'cutoff': q, 'window': k,
        'tail': {name: str(value) if isinstance(value, F) else value for name, value in tail.items()},
        'epsilon': str(e), 'cutoff_maximum': str(A), 'coefficient_upper': str(upper_M),
        'gap_ratio': str(ratio), 'finite_candidates': candidates, 'witness': witness,
        'normalized_kth_power_lower': str(max(F(1), (1-e)*A)),
        'stability_test': comparison(upper_test), 'instability_test': comparison(lower_test),
        'classification': 'certified_stable' if stable else 'certified_not_exponentially_stable' if not_stable else 'inconclusive',
        'accuracy_certificate': {'delta': str(delta), 'cutoff': q_accuracy, 'epsilon': str(e_accuracy),
                                 'Hbar': str(Hbar), 'all_windows_at_least': k0,
                                 'claim': 'abs(k*log(rho/lambda)-log(M_m)) <= delta for every integer k >= threshold'},
        'scope': 'Rational normalized positive matrices with an exactly verified Perron frame; not arbitrary floating or feedback inputs',
        'proof_boundary': 'Generic cutoff, finite-window and all-later-window accuracy implications are Lean-checked; the automatic minorization-tail construction remains classically justified rather than separately Lean-formalized',
    }


def verify_certificate(data, certificate):
    require(certificate == certify(data), 'Certificate does not match exact recomputation')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    create = sub.add_parser('certify')
    create.add_argument('input', type=Path)
    create.add_argument('--output', type=Path, required=True)
    verify = sub.add_parser('verify')
    verify.add_argument('input', type=Path)
    verify.add_argument('certificate', type=Path)
    args = parser.parse_args()
    data = json.loads(args.input.read_text())
    if args.command == 'verify':
        verify_certificate(data, json.loads(args.certificate.read_text()))
        print('PASS: quantitative certificate matches exact recomputation')
    else:
        result = certify(data)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(result, indent=2, sort_keys=True)+'\n')
        print(json.dumps({'status': 'PASS', 'classification': result['classification'],
                          'accuracy_certificate': result['accuracy_certificate']}, indent=2))


if __name__ == '__main__':
    main()
