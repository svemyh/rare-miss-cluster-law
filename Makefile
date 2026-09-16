.PHONY: check check-exact check-lean check-package paper citations

check: check-exact check-lean check-package

check-exact:
	mkdir -p build
	python3 verify.py --output build/check-results.json > build/exact-check.log
	python3 -I -O verify.py --output build/check-results-optimized.json > build/exact-check-optimized.log
	cmp build/check-results.json build/check-results-optimized.json
	@echo "Exact checks passed; normal and optimized receipts match."

check-lean:
	cd lean && python3 check.py

check-package:
	python3 scripts/check_package.py

paper:
	python3 paper/build.py

citations:
	node literature-audit/protocol-sources/count-citation-records.mjs
