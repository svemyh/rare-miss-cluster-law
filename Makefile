.PHONY: check check-exact check-lean check-quantitative check-package paper citations

check: check-exact check-lean check-quantitative check-package

check-exact:
	mkdir -p build
	python3 verify.py --output build/check-results.json > build/exact-check.log
	python3 -I -O verify.py --output build/check-results-optimized.json > build/exact-check-optimized.log
	cmp build/check-results.json build/check-results-optimized.json
	@echo "Exact checks passed; normal and optimized receipts match."

check-lean:
	cd lean && python3 check.py

check-quantitative:
	mkdir -p build
	python3 -m unittest discover -s tests -v
	python3 quantitative.py certify fixtures/quantitative-reset.json --output build/quantitative-reset.json
	python3 -I -O quantitative.py certify fixtures/quantitative-reset.json --output build/quantitative-reset-optimized.json
	cmp build/quantitative-reset.json build/quantitative-reset-optimized.json
	python3 quantitative.py verify fixtures/quantitative-reset.json build/quantitative-reset.json

check-package:
	python3 scripts/check_package.py

paper:
	python3 paper/build.py

citations:
	node literature-audit/protocol-sources/count-citation-records.mjs
