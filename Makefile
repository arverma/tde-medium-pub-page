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
		if [ "$$(grep -c '<title>' "$$f")" -ne 1 ]; then \
			echo "$$f: expected exactly one title"; fail=1; \
		fi; \
		if [ "$$(grep -c 'name="description"' "$$f")" -ne 1 ]; then \
			echo "$$f: expected exactly one meta description"; fail=1; \
		fi; \
		if ! grep -q 'property="og:title"' "$$f"; then \
			echo "$$f: missing Open Graph metadata"; fail=1; \
		fi; \
		for attr in og:description og:url og:image; do \
			if ! grep -q "property=\"$$attr\"" "$$f"; then \
				echo "$$f: missing Open Graph $$attr"; fail=1; \
			fi; \
		done; \
		if ! grep -q 'name="twitter:card"' "$$f"; then \
			echo "$$f: missing Twitter metadata"; fail=1; \
		fi; \
		if ! grep -qi 'Medium publication' "$$f"; then \
			echo "$$f: title/description must mention Medium publication"; fail=1; \
		fi; \
		if ! grep -q 'href="https://arverma.dev/"' "$$f"; then \
			echo "$$f: missing arverma.dev footer link"; fail=1; \
		fi; \
		if grep -q '<img' "$$f" && ! grep -q 'alt=' "$$f"; then \
			echo "$$f: image missing alt text"; fail=1; \
		fi; \
		if grep -q '<img' "$$f" && ! grep -q 'width=' "$$f"; then \
			echo "$$f: image missing width"; fail=1; \
		fi; \
		if grep -q '<img' "$$f" && ! grep -q 'height=' "$$f"; then \
			echo "$$f: image missing height"; fail=1; \
		fi; \
		for href in / editors.html faqs.html partner-policy.html; do \
			if ! grep -q "href=\"$$href\"" "$$f"; then \
				echo "$$f: missing nav link to $$href"; fail=1; \
			fi; \
		done; \
		if [ "$$(grep -c '<title>' guidelines.html)" -ne 1 ] || \
			[ "$$(grep -c 'name="description"' guidelines.html)" -ne 1 ] || \
			[ "$$(grep -c '<h1' guidelines.html)" -ne 1 ]; then \
			echo "guidelines.html: expected one title, description, and h1"; fail=1; \
		fi; \
		if ! grep -q 'property="og:title"' guidelines.html || \
			! grep -q 'property="og:description"' guidelines.html || \
			! grep -q 'href="https://arverma.dev/"' guidelines.html; then \
			echo "guidelines.html: missing required social metadata or footer link"; fail=1; \
		fi; \
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
	if ! grep -q '"@type": "Organization"' index.html; then \
		echo "index.html: missing Organization JSON-LD"; fail=1; \
	fi; \
	if ! grep -q '"@type": "FAQPage"' faqs.html; then \
		echo "faqs.html: missing FAQPage JSON-LD"; fail=1; \
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
