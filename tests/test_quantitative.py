import copy
from fractions import Fraction as F
import json
from pathlib import Path
import unittest

import quantitative as q

ROOT = Path(__file__).resolve().parents[1]


class QuantitativeTests(unittest.TestCase):
    def setUp(self):
        self.data = json.loads((ROOT/'fixtures/quantitative-reset.json').read_text())

    def test_reset_certificate(self):
        result = q.certify(self.data)
        self.assertEqual(result['epsilon'], '0')
        self.assertEqual(result['cutoff_maximum'], '10349/5000')
        self.assertEqual(result['coefficient_upper'], '10349/5000')
        self.assertEqual(result['finite_candidates'], 8)
        self.assertEqual(result['witness'], {'misses': 2, 'gaps_matrix_order': [0], 'length': 2})
        self.assertEqual(result['classification'], 'certified_stable')
        self.assertEqual(result['accuracy_certificate']['all_windows_at_least'], 129)

    def test_conservative_not_exact_stability_threshold(self):
        expected = {6: 'certified_not_exponentially_stable', 7: 'inconclusive',
                    8: 'inconclusive', 9: 'inconclusive', 10: 'certified_stable'}
        for k, classification in expected.items():
            with self.subTest(window=k):
                self.data['window'] = k
                result = q.certify(self.data)
                self.assertEqual(result['classification'], classification)
                exact_test = F(9, 10)**(k-1)*F(10349, 5000)
                if classification == 'certified_stable':
                    self.assertLess(exact_test, 1)
                elif classification == 'certified_not_exponentially_stable':
                    self.assertGreaterEqual(exact_test, 1)

    def test_nonreset_minorization_and_known_gap(self):
        self.data.update(normalized_success=[['1/4', '3/4'], ['3/4', '1/4']],
                         normalized_miss=[['1/5', '3/2'], ['1/2', '1/5']], left=['1/2', '1/2'],
                         budget=2, cutoff=4, window=20)
        result = q.certify(self.data)
        self.assertEqual(result['tail']['kind'], 'minorization')
        self.assertEqual(result['tail']['alpha'], '1/4')
        self.assertEqual(result['epsilon'], '81/128')
        self.assertEqual(result['cutoff_maximum'], '313/200')
        self.assertEqual(result['witness']['gaps_matrix_order'], [1])

    def test_empty_word_can_attain_maximum(self):
        self.data['normalized_miss'] = [['1/4', '1/4'], ['1/4', '1/4']]
        result = q.certify(self.data)
        self.assertEqual(result['cutoff_maximum'], '1')
        self.assertEqual(result['witness']['misses'], 0)
        self.assertEqual(result['classification'], 'certified_stable')

    def test_nominal_nondecay_is_captured_by_all_successes(self):
        self.data.update(normalized_success=[['1/4', '3/4'], ['3/4', '1/4']],
                         normalized_miss=[['1/4', '1/4'], ['1/4', '1/4']],
                         left=['1/2', '1/2'], cutoff=4, window=20)
        self.data['lambda'] = '1'
        result = q.certify(self.data)
        self.assertEqual(result['cutoff_maximum'], '1')
        self.assertEqual(result['classification'], 'certified_not_exponentially_stable')

    def test_corrupted_certificate_is_rejected(self):
        report = q.certify(self.data)
        for key, value in [('cutoff_maximum', '1'), ('classification', 'inconclusive')]:
            bad = copy.deepcopy(report)
            bad[key] = value
            with self.assertRaisesRegex(ValueError, 'exact recomputation'):
                q.verify_certificate(self.data, bad)

    def test_reject_invalid_certification_conditions(self):
        variants = [dict(window=5), dict(budget=0), dict(cutoff=0), dict(accuracy='0'),
                    dict(right=['2', '2']), dict(left=['1/2', '1/2']),
                    dict(normalized_miss=[['0', '1/10'], ['20', '1/10']]), dict(**{'lambda': 0.9})]
        for change in variants:
            with self.subTest(change=change):
                bad = copy.deepcopy(self.data)
                bad.update(change)
                with self.assertRaises((ValueError, TypeError)):
                    q.certify(bad)

    def test_refuse_insufficient_nonreset_tail(self):
        self.data.update(normalized_success=[['1/4', '3/4'], ['3/4', '1/4']],
                         left=['1/2', '1/2'])
        with self.assertRaisesRegex(ValueError, 'error below one'):
            q.certify(self.data)

    def test_resource_guard_is_not_a_mathematical_claim(self):
        model = q.Model.parse(self.data)
        with self.assertRaisesRegex(ValueError, 'MAX_CANDIDATES'):
            q.cutoff(model, 10, 100)


if __name__ == '__main__':
    unittest.main()
