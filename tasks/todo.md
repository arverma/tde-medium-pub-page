# SEO/AEO/GEO Task Checklist

## Phase 1: Crawlability and page identity

### Task 1: Add explicit page headings and answer-first introductions

- [x] Add one meaningful `h1` to `index.html` and `editors.html`.
- [x] Add concise, visible explanations of who the page is for, what happens
  after submission, and what the form is for.
- [x] Preserve the existing Google Form embeds and visual hierarchy.

**Verification:** Inspect all indexable pages for exactly one `h1`; run
`make check`; verify the new copy is visible with JavaScript disabled.

### Task 2: Add canonical and sharing metadata

- [x] Add absolute canonical URLs to every indexable page.
- [x] Add unique Open Graph and Twitter/X card metadata.
- [x] Add explicit robots metadata for indexable pages and the legacy redirect.

**Verification:** Parse each document head and confirm metadata is unique,
absolute where required, and points to the intended page.

### Task 3: Add crawl discovery files

- [x] Create `robots.txt` with a sitemap reference.
- [x] Create `sitemap.xml` containing only canonical indexable URLs.
- [x] Keep `guidelines.html` out of the sitemap.

**Verification:** Validate XML, fetch both files from the local server, and
confirm every sitemap URL has a matching page/canonical.

## Checkpoint: Crawlability

- [x] `make check` passes.
- [x] Canonical and sitemap URL sets agree.
- [x] No indexable page is missing a title, description, or `h1`.

## Phase 2: Entity and answer-engine understanding

### Task 4: Add entity and page JSON-LD

- [x] Add a stable `Organization` entity with site URL, logo, email, and
  verified social profiles.
- [x] Add `WebSite`/`WebPage` relationships and breadcrumbs where useful.
- [x] Ensure all properties are supported by visible page content.

**Verification:** Run JSON-LD through a validator and inspect the rendered
HTML for consistency.

### Task 5: Improve FAQ extraction

- [x] Change question labels to heading elements with clear question wording.
- [x] Pair each question directly with its answer.
- [x] Add `FAQPage` JSON-LD only for the visible FAQ questions and answers.
- [x] Keep the existing collapsible UX if it remains accessible.

**Verification:** Test keyboard interaction and collapsed/open states; validate
structured data; confirm each answer starts with a direct response.

### Task 6: Add trust and freshness signals

- [x] Add publication scope, editorial contact, and Medium relationship in
  crawlable copy.
- [x] Add a visible last-updated date to FAQ/policy content.
- [x] Preserve primary-source links for Medium rules and policies.

**Verification:** Check that dates and source links are visible, current, and
consistent with JSON-LD `dateModified`.

## Phase 3: Measurement and maintenance

### Task 7: Extend repository checks

- [x] Add metadata, canonical, sitemap, JSON-LD, and one-`h1` checks to
  `make check`.
- [x] Keep checks dependency-free and compatible with GitHub Actions.

**Verification:** Run passing and intentionally failing fixtures or targeted
  shell checks, then run the normal `make check`.

### Task 8: Document maintenance and prepare submission

- [x] Document metadata/schema ownership and update triggers in `README.md`.
- [ ] Submit the sitemap to Google Search Console and Bing Webmaster Tools
  after deployment.
- [ ] Record baseline indexing/crawl observations after deployment.

**Verification:** Pending deployment. The current live URLs return HTTP 404;
  do not submit until both files return HTTP 200.

## Final checkpoint

- [x] All implementation tasks complete.
- [x] `make check` passes locally.
- [x] Mobile and desktop rendering checked.
- [x] No new site-generated console, navigation, or accessibility regressions.
- [ ] Submit and verify the sitemap on the deployed domain. Blocked: the live
  domain currently returns HTTP 404 for both required files.

## Re-audit status — 2026-11-02

All code, documentation, local validation, and browser-verifiable tasks are
complete. The only remaining items require publishing the changes and access to
Google Search Console/Bing Webmaster Tools.
