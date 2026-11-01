# Implementation Plan: SEO, AEO, and GEO Improvements

## Overview

Improve the static Towards Data Engineering application site so search engines
and answer engines can reliably discover, understand, and cite its pages. The
plan preserves the existing visual language and Google Form workflow while
adding stronger page semantics, crawl signals, entity information, and
answer-first content.

## Audit Summary

### High priority — resolved

- [x] `index.html` and `editors.html` do not contain a visible `h1`, so their
  primary purpose is less explicit than their titles and descriptions.
- [x] No primary page has a canonical URL, Open Graph metadata, or social preview
  metadata.
- [x] There is no `robots.txt` or `sitemap.xml`, and the sitemap is not currently
  advertised to crawlers.
- [x] The home and editor pages are dominated by Google Form iframes. The
  application experience is usable, but the form content is not reliable
  crawlable page content.
- [x] There is no structured entity markup for Towards Data Engineering or
  machine-readable page relationships.

### Medium priority — resolved

- [x] FAQ questions use styled paragraphs instead of heading elements, and the
  answers are grouped under only two broad `<details>` sections. This is
  readable, but weaker for question-level extraction by answer engines.
- [x] The FAQ page has no `FAQPage` JSON-LD. It may not produce a Google rich
  result because FAQ rich-result eligibility is restricted, but valid markup
  can still clarify the visible Q&A content.
- [x] `guidelines.html` is a client/meta-refresh redirect with a relative
  canonical. It should remain as a legacy compatibility URL, but it should not
  be treated as an indexable content page.
- [x] There is no explicit “last updated” signal on the FAQ page even though its
  policy content depends on changing Medium rules.

### Low priority / explicitly not planned initially

- Do not add keyword stuffing, hidden text, generated low-value pages, or
  speculative `llms.txt` support.
- Do not claim that schema guarantees rich results or AI citations.
- Do not add analytics or third-party SEO tooling unless a later measurement
  requirement justifies it.

## Architecture Decisions

- Use absolute canonical URLs based on `https://tde.arverma.dev/`.
- Keep the site static and dependency-free; add only static metadata/files and
  small updates to the existing `make check` validation.
- Use JSON-LD, preferably one `Organization` entity reused through `@id`, plus
  page-specific `WebPage`/`FAQPage` data.
- Keep all important explanations in visible HTML. Structured data must mirror
  that content rather than introduce hidden claims.
- Treat Google Forms as the conversion surface, not the source of the site's
  explanatory content.

## Task List

### Phase 1: Crawlability and page identity

- [x] Task 1: Add explicit page headings and answer-first introductions.
- [x] Task 2: Add canonical, robots, Open Graph, and social metadata to every
  indexable page.
- [x] Task 3: Add `robots.txt` and `sitemap.xml`, excluding the legacy
  redirect-only URL.

### Checkpoint: Crawlability

- [x] Every indexable page has exactly one meaningful `h1`.
- [x] Canonicals resolve to the intended HTTPS URLs.
- [x] Sitemap URLs match the canonical URL set.
- [x] `make check` passes.

### Phase 2: Entity and answer-engine understanding

- [x] Task 4: Add Organization, WebSite, WebPage, and breadcrumb JSON-LD where
  each type is supported by visible page content.
- [x] Task 5: Restructure FAQ questions as heading/answer pairs and add
  FAQPage JSON-LD that mirrors the visible answers.
- [x] Task 6: Add editorial trust and freshness signals: a concise publication
  description, contact path, Medium profile relationship, source links, and a
  visible FAQ/policy update date.

### Checkpoint: Semantics

- [x] JSON-LD parses without errors and contains no claims absent from visible
  content.
- [x] Each FAQ question has one directly associated answer.
- [x] FAQ answers begin with concise, independently understandable responses.
- [x] All source and social links remain valid and intentional.

### Phase 3: Measurement and maintenance

- [x] Task 7: Extend `make check` to validate metadata, canonical coverage,
  sitemap coverage, structured-data presence, and one-`h1` requirements.
- [x] Task 8: Document the SEO/AEO/GEO maintenance rules in `README.md` and
  define a launch checklist for Search Console/Bing Webmaster Tools
  submission and periodic validation.

### Checkpoint: Complete

- [x] `make check` passes locally and in GitHub Actions.
- [x] HTML and structured data pass a validator.
- [ ] Sitemap and robots files are reachable from the deployed domain.
- [ ] Search Console and Bing Webmaster Tools have the sitemap submitted.
- [x] A representative mobile and desktop crawl/render check has no blocking
  console or navigation errors.

## Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Incorrect absolute URLs after a domain change | High | Centralize the production origin in the plan/checks and verify deployed links. |
| Structured data drifts from visible policy copy | Medium | Keep JSON-LD adjacent to the source content and add automated presence checks. |
| FAQ markup creates expectations of a rich result | Medium | Treat it as semantic clarification, not a ranking or rich-result guarantee. |
| Google Form remains the only actionable content on application pages | Medium | Add crawlable eligibility, process, and expectations copy before the iframe. |
| Medium policy changes make answers stale | High | Keep source links and a visible `dateModified`/last-updated value; review on policy changes. |

## Verification References

The recommendations align with current Google Search Central guidance on
canonical URLs, sitemaps, meta descriptions, robots directives, and structured
data:

- https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls
- https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap
- https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data
- https://developers.google.com/search/docs/appearance/structured-data/sd-policies

## Open Questions

- Should the site expose a separate public “About TDE” page, or should the
  publication/entity description stay on the existing writer page?
- Which production date should be used for `dateModified` when Medium policy
  links change?
- Should Search Console/Bing verification be done via DNS, HTML files, or
  meta tags?

## Re-audit status — 2026-11-02

All repository implementation work and local validation are complete. The
deployed domain currently returns HTTP 404 for both
`https://tde.arverma.dev/robots.txt` and `https://tde.arverma.dev/sitemap.xml`,
so deployment and webmaster submission remain blocked until the changes are
published to the GitHub Pages source branch.
