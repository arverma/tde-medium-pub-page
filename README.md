# Towards Data Engineering — publication site

Static site for [Towards Data Engineering](https://medium.com/towards-data-engineering) on Medium: writer requests, FAQs, and guidelines (Editors apply page still stubbed).

Built for **GitHub Pages**. No build step.

## Local preview

```bash
make serve
```

Or: `python3 -m http.server 8080`. Then open `http://localhost:8765` (default `make serve` port) or `8080`.

```bash
make check   # required files + internal nav links
```

GitHub Actions runs `make check` on push and pull requests.

The layout is responsive for phone, tablet, and desktop (fluid padding, wrapping/scrollable nav, scaled form height, stacked footer on small screens).

## Deploy on GitHub Pages

1. Push this repo to GitHub.
2. **Settings → Pages → Build and deployment**
3. Source: **Deploy from a branch**
4. Branch: `main` (or `master`), folder: `/` (root)
5. Save. The site will be at `https://<user>.github.io/<repo>/`

Point your Medium About CTA at that URL (or the Writers page, which is the homepage).

## Edit content

| What | Where |
|---|---|
| Writer intro + form | `index.html` |
| Google Form URL / iframe height | `index.html` — iframe `src`; height in `css/global.css` (default `1600px`) |
| FAQs (writers / editors accordions) | `faqs.html` |
| Guidelines (writers / editors accordions) | `guidelines.html` |
| Editors apply stub | `editors.html` |
| Nav, footer, styles | Each HTML file; `css/global.css` |
| Theme | Black / white + brand blue `#004AAD`; follows OS `prefers-color-scheme` |

FAQs and Guidelines use native `<details>` blocks: **For writers** open by default, **For editors** closed. Copy is summarized from Medium Help; keep links current:

- [AI content policy](https://help.medium.com/hc/en-us/articles/22576852947223-Artificial-Intelligence-AI-content-policy)
- [Partner Program](https://medium.com/partner-program) / [earnings calculation](https://help.medium.com/hc/en-us/articles/360036691193-Medium-Partner-Program-earnings-calculation)
- [Distribution / Boost guidelines](https://help.medium.com/hc/en-us/articles/360006362473-Medium-s-Distribution-Guidelines-How-curators-review-stories-for-Boost-General-and-Network-Distribution)

Form embed URL currently:

```
https://docs.google.com/forms/d/e/1FAIpQLSeVCp8TaDkdbPjp7aX94Ck4LaxaVjkb65P8IfoFq_Y25jFF8w/viewform?embedded=true
```

Keep `?embedded=true` when swapping forms.

## Note on the form

The Google Form iframe uses Google’s default (light) chrome. The surrounding page follows the system light/dark preference; that contrast cannot be restyled from outside the iframe.
