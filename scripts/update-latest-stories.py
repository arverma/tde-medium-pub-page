#!/usr/bin/env python3
"""
Update Latest Stories in index.html from the Medium RSS feed.

Mirrors the approach from arverma.dev (src/lib/medium.ts and Writing.astro):
- Fetch https://medium.com/feed/towards-data-engineering at update time
- Normalize URLs (strip query/hash like Medium's ?source= tracking) so URLs compare and link cleanly
- Take the 6 newest items
- Fall back to leaving index.html unchanged if Medium is unreachable (safe failure mode)
"""

import sys
import html
from urllib.request import Request, urlopen
from urllib.parse import urlparse
from xml.etree import ElementTree as ET

FEED_URL = "https://medium.com/feed/towards-data-engineering"
INDEX_FILE = "index.html"
START_MARKER = "<!-- LATEST_STORIES_START -->"
END_MARKER = "<!-- LATEST_STORIES_END -->"
MAX_ITEMS = 6


def normalize_url(url):
    """
    Drop query/hash (e.g. Medium's ?source=rss tracking) so URLs compare and link cleanly.
    Matches arverma.dev src/lib/medium.ts normalizeUrl().
    """
    u = urlparse(url)
    return f"{u.scheme}://{u.netloc}{u.path}"


def fetch_latest_stories():
    """
    Fetch the RSS feed and return the latest stories.
    Returns None if fetch fails (timeout, network error, HTTP error).
    """
    try:
        req = Request(FEED_URL, headers={"User-Agent": "TDE-Site-Updater/1.0"})
        with urlopen(req, timeout=5) as response:
            if response.status != 200:
                print(f"RSS HTTP {response.status}", file=sys.stderr)
                return None
            content = response.read()

        root = ET.fromstring(content)
        items = []

        for item in root.findall(".//item")[:MAX_ITEMS]:
            title_elem = item.find("title")
            link_elem = item.find("link")

            if title_elem is not None and link_elem is not None:
                title = title_elem.text or ""
                link = link_elem.text or ""
                if title and link:
                    items.append({"title": title, "url": normalize_url(link)})

        return items if items else None

    except Exception as e:
        print(f"Fetch failed: {e}", file=sys.stderr)
        return None


def generate_html_block(stories):
    """Generate the HTML block for the stories list."""
    lines = ['          <ul class="checklist">']
    for story in stories:
        title_escaped = html.escape(story["title"], quote=True)
        url_escaped = html.escape(story["url"], quote=True)
        lines.append(
            f'            <li><a href="{url_escaped}" target="_blank" rel="noopener">{title_escaped}</a></li>'
        )
    lines.append("          </ul>")
    return "\n".join(lines)


def update_index_file(new_html_block):
    """Update index.html with the new stories block. Returns True if file changed."""
    try:
        with open(INDEX_FILE, "r", encoding="utf-8") as f:
            content = f.read()

        start_idx = content.find(START_MARKER)
        end_idx = content.find(END_MARKER)

        if start_idx == -1 or end_idx == -1:
            print("Markers not found in index.html", file=sys.stderr)
            return False

        new_content = (
            content[: start_idx + len(START_MARKER)]
            + "\n"
            + new_html_block
            + "\n          "
            + content[end_idx:]
        )

        if new_content != content:
            with open(INDEX_FILE, "w", encoding="utf-8") as f:
                f.write(new_content)
            print("Updated index.html with latest stories")
            return True
        else:
            print("No changes needed")
            return False

    except Exception as e:
        print(f"Failed to update index.html: {e}", file=sys.stderr)
        return False


def main():
    """
    Single source for the Latest Stories list (like arverma.dev getPosts()).
    If Medium is unreachable, leave index.html unchanged (fallback behavior).
    """
    stories = fetch_latest_stories()

    if stories is None:
        print("Medium unreachable or empty, leaving index.html unchanged")
        sys.exit(0)

    new_html_block = generate_html_block(stories)
    update_index_file(new_html_block)
    sys.exit(0)


if __name__ == "__main__":
    main()
