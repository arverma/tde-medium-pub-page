.PHONY: help serve serve-restart check

SITE_ORIGIN ?= https://tde.arverma.dev

PORT ?= 8765

help:
	@echo "Targets:"
	@echo "  make serve          Serve the site at http://localhost:$(PORT)"
	@echo "  make serve-restart  Stop anything on $(PORT), then serve"
	@echo "  make check          Verify required files and internal links"
	@echo "  make help           Show this help"

serve:
	@if lsof -nP -iTCP:$(PORT) -sTCP:LISTEN >/dev/null 2>&1; then \
		echo "Already serving on http://localhost:$(PORT)"; \
	else \
		echo "Serving on http://localhost:$(PORT)"; \
		python3 -m http.server $(PORT); \
	fi

serve-restart:
	@pid=$$(lsof -nP -iTCP:$(PORT) -sTCP:LISTEN -t 2>/dev/null | head -1); \
	if [ -n "$$pid" ]; then kill $$pid && echo "Stopped PID $$pid"; fi; \
	echo "Serving on http://localhost:$(PORT)"; \
	python3 -m http.server $(PORT)

check:
	@fail=0; \
	for f in index.html editors.html faqs.html guidelines.html partner-policy.html robots.txt sitemap.xml css/global.css README.md js/site.js; do \
		if [ ! -f "$$f" ]; then echo "missing: $$f"; fail=1; fi; \
	done; \
	for f in index.html editors.html faqs.html partner-policy.html; do \
		if ! grep -q 'href="css/global.css"' "$$f"; then \
			echo "$$f: missing css/global.css link"; fail=1; \
		fi; \
		if ! grep -q '<h1' "$$f"; then \
			echo "$$f: missing h1"; fail=1; \
		fi; \
		if [ "$$(grep -c '<h1' "$$f")" -ne 1 ]; then \
			echo "$$f: expected exactly one h1"; fail=1; \
		fi; \
		if ! grep -q '<link rel="canonical"' "$$f"; then \
			echo "$$f: missing canonical"; fail=1; \
		fi; \
		if ! grep -q 'property="og:title"' "$$f"; then \
			echo "$$f: missing Open Graph metadata"; fail=1; \
		fi; \
		if ! grep -q 'name="twitter:card"' "$$f"; then \
			echo "$$f: missing Twitter metadata"; fail=1; \
		fi; \
		for href in index.html editors.html faqs.html partner-policy.html; do \
			if ! grep -q "href=\"$$href\"" "$$f"; then \
				echo "$$f: missing nav link to $$href"; fail=1; \
			fi; \
		done; \
		if ! grep -q 'src="js/site.js"' "$$f"; then \
			echo "$$f: missing js/site.js"; fail=1; \
		fi; \
	done; \
	if ! grep -q 'url=faqs.html' guidelines.html; then \
		echo "guidelines.html: missing redirect to faqs.html"; fail=1; \
	fi; \
	if ! grep -q "Sitemap: $(SITE_ORIGIN)/sitemap.xml" robots.txt; then \
		echo "robots.txt: missing sitemap reference"; fail=1; \
	fi; \
	for href in $(SITE_ORIGIN)/ $(SITE_ORIGIN)/editors.html $(SITE_ORIGIN)/faqs.html $(SITE_ORIGIN)/partner-policy.html; do \
		if ! grep -q "$$href" sitemap.xml; then \
			echo "sitemap.xml: missing $$href"; fail=1; \
		fi; \
	done; \
	if grep -q 'guidelines.html' sitemap.xml; then \
		echo "sitemap.xml: legacy guidelines URL must not be included"; fail=1; \
	fi; \
	if ! grep -q 'application/ld+json' index.html; then \
		echo "index.html: missing structured data"; fail=1; \
	fi; \
	if ! grep -q 'application/ld+json' faqs.html; then \
		echo "faqs.html: missing structured data"; fail=1; \
	fi; \
	if [ ! -f assets/favicon-32.png ]; then \
		echo "missing: assets/favicon-32.png"; fail=1; \
	fi; \
	if ! grep -q '004aad\|004AAD\|#004AAD' css/global.css; then \
		echo "css/global.css: brand color #004AAD not found"; fail=1; \
	fi; \
	if ! grep -q 'docs.google.com/forms' index.html; then \
		echo "index.html: Google Form embed missing"; fail=1; \
	fi; \
	if [ $$fail -ne 0 ]; then \
		echo "check failed"; exit 1; \
	fi; \
	echo "check passed"
