#!/usr/bin/env python3
"""
Update the Latest Stories section in index.html from the Medium RSS feed.
Fetches https://medium.com/feed/towards-data-engineering, takes the 6 newest items,
strips tracking params, and updates the HTML block between markers.
"""

import sys
import re
import html
from urllib.request import Request, urlopen
from urllib.parse import urlparse, parse_qs, urlencode, urlunparse
from xml.etree import ElementTree as ET

FEED_URL = "https://medium.com/feed/towards-data-engineering"
INDEX_FILE = "index.html"
START_MARKER = "<!-- LATEST_STORIES_START -->"
END_MARKER = "<!-- LATEST_STORIES_END -->"
MAX_ITEMS = 6


def strip_tracking_params(url):
    """Remove ?source= and other tracking params from URL."""
    parsed = urlparse(url)
    query_params = parse_qs(parsed.query)
    
    # Remove tracking params
    cleaned_params = {k: v for k, v in query_params.items() 
                     if k not in ['source', 'gi']}
    
    cleaned_query = urlencode(cleaned_params, doseq=True) if cleaned_params else ''
    
    return urlunparse((
        parsed.scheme,
        parsed.netloc,
        parsed.path,
        parsed.params,
        cleaned_query,
        parsed.fragment
    ))


def fetch_latest_stories():
    """Fetch the RSS feed and return the latest stories."""
    try:
        req = Request(
            FEED_URL,
            headers={'User-Agent': 'TDE-Site-Updater/1.0'}
        )
        
        with urlopen(req, timeout=10) as response:
            content = response.read()
        
        root = ET.fromstring(content)
        
        # Handle RSS 2.0 format
        items = []
        for item in root.findall('.//item')[:MAX_ITEMS]:
            title_elem = item.find('title')
            link_elem = item.find('link')
            creator_elem = item.find('{http://purl.org/dc/elements/1.1/}creator')
            
            if title_elem is not None and link_elem is not None:
                title = title_elem.text or ''
                link = link_elem.text or ''
                creator = creator_elem.text if creator_elem is not None else None
                
                # Strip tracking params
                link = strip_tracking_params(link)
                
                items.append({
                    'title': title,
                    'link': link,
                    'creator': creator
                })
        
        return items
    
    except Exception as e:
        print(f"Failed to fetch feed: {e}", file=sys.stderr)
        return None


def generate_html_block(stories):
    """Generate the HTML block for the stories list."""
    lines = ['          <ul class="checklist">']
    
    for story in stories:
        title_escaped = html.escape(story['title'], quote=True)
        link_escaped = html.escape(story['link'], quote=True)
        
        lines.append(f'            <li><a href="{link_escaped}" target="_blank" rel="noopener">{title_escaped}</a></li>')
    
    lines.append('          </ul>')
    
    return '\n'.join(lines)


def update_index_file(new_html_block):
    """Update the index.html file with the new stories block."""
    try:
        with open(INDEX_FILE, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the markers
        start_idx = content.find(START_MARKER)
        end_idx = content.find(END_MARKER)
        
        if start_idx == -1 or end_idx == -1:
            print("Markers not found in index.html", file=sys.stderr)
            return False
        
        # Replace the block between markers
        new_content = (
            content[:start_idx + len(START_MARKER)] +
            '\n' + new_html_block + '\n          ' +
            content[end_idx:]
        )
        
        # Only write if content changed
        if new_content != content:
            with open(INDEX_FILE, 'w', encoding='utf-8') as f:
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
    stories = fetch_latest_stories()
    
    if stories is None:
        print("Fetch failed, leaving index.html unchanged")
        sys.exit(0)
    
    if not stories:
        print("No stories found in feed, leaving index.html unchanged")
        sys.exit(0)
    
    new_html_block = generate_html_block(stories)
    update_index_file(new_html_block)
    
    sys.exit(0)


if __name__ == '__main__':
    main()
