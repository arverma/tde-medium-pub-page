# Towards Data Engineering

Public site for the [Towards Data Engineering](https://medium.com/towards-data-engineering) publication on Medium. Live at [tde.arverma.dev](https://tde.arverma.dev).

| Page | File | What it does |
|---|---|---|
| #Write@TDE | `index.html` | Writer request form |
| #Edit@TDE | `editors.html` | Editor application form. The publication is in Medium’s [Editor Partner Program](https://medium.com/blog/partner-program-update-starting-june-1-were-rewarding-editors-for-stories-they-edit-aaec12a97cea) |
| FAQs | `faqs.html` | Writer and editor rules. Sections start collapsed. `guidelines.html` redirects here |

Footer links: [Medium](https://medium.com/towards-data-engineering), [email](mailto:towardsdataengg@gmail.com), [X](https://x.com/TowardsDataEngg), [LinkedIn](https://www.linkedin.com/company/towards-data-engineering/).

Static HTML and CSS. No build step. GitHub Pages serves `main` from the repo root. The theme is black / white with brand blue `#004AAD` and follows the system color scheme. Google Form iframes stay on Google’s light chrome.

## Develop

```bash
make serve   # http://localhost:8765
make check   # required files and nav links
```

`make check` also runs in GitHub Actions on push and pull requests.

To change a form, edit the iframe `src` in `index.html` or `editors.html` and keep `?embedded=true`. FAQ copy is a summary of Medium Help. Keep these current:

- [AI content policy](https://help.medium.com/hc/en-us/articles/22576852947223-Artificial-Intelligence-AI-content-policy)
- [Partner Program](https://medium.com/partner-program) and [earnings](https://help.medium.com/hc/en-us/articles/360036691193-Medium-Partner-Program-earnings-calculation)
- [Distribution / Boost](https://help.medium.com/hc/en-us/articles/360006362473-Medium-s-Distribution-Guidelines-How-curators-review-stories-for-Boost-General-and-Network-Distribution)
- [Medium Rules](https://policy.medium.com/medium-rules-30e5502c4eb4)

Nav labels are duplicated in each HTML file. Change them together.

## Contribute

Fixes and clearer copy are welcome. Open a pull request.

- Correct outdated Medium rules, broken links, or typos.
- Keep the voice plain. Don’t add policy that isn’t in Medium Help or this publication’s own forms.
- Match the existing layout. One change per pull request.
- Run `make check` before you push.
