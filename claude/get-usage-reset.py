#!/usr/bin/env python3
"""Fetch Claude Code /usage stats and cache to ~/.claude/usage_reset_cache"""
import pexpect, re, time, os, json

CACHE_FILE = os.path.expanduser('~/.claude/usage_reset_cache')

def fetch_usage(debug=False):
    child = pexpect.spawn('claude', timeout=30, encoding='utf-8', cwd=os.path.expanduser('~/.claude'))
    time.sleep(6)
    child.send('/usage\r')
    time.sleep(5)

    all_output = ''
    try:
        while True:
            chunk = child.read_nonblocking(size=4096, timeout=1)
            all_output += chunk
    except:
        pass
    child.terminate()

    # Strip ANSI escape sequences (broad pattern)
    ansi_escape = re.compile(r'\x1b\[[0-9;]*[a-zA-Z]|\x1b[=>]|\r|\x1b\][^\x07]*\x07')
    clean = ansi_escape.sub('', all_output)

    if debug:
        print("CLEAN:", repr(clean[-800:]))

    result = {}

    # Current session: percentage and reset time
    idx = clean.find('Current session')
    if idx >= 0:
        section = clean[idx:idx+150]
        if debug:
            print("SESSION SECTION:", repr(section))
        m_pct = re.search(r'(\d{1,2})%', section)
        m_time = re.search(r'(\d{1,2}(?::\d{2})?)\s*(am|pm)', section)
        if m_pct:
            result['session_pct'] = m_pct.group(1)
        if m_time:
            result['reset_time'] = m_time.group(1) + m_time.group(2)

    # Current week: percentage
    idx2 = clean.find('Current week')
    if idx2 >= 0:
        section2 = clean[idx2:idx2+100]
        if debug:
            print("WEEK SECTION:", repr(section2))
        m_pct2 = re.search(r'(\d{1,2})%', section2)
        if m_pct2:
            result['week_pct'] = m_pct2.group(1)

    return result if result else None

if __name__ == '__main__':
    import sys
    debug = '--debug' in sys.argv

    # Skip if cache is fresh (< 2 minutes old)
    if not debug and os.path.exists(CACHE_FILE):
        age = time.time() - os.path.getmtime(CACHE_FILE)
        if age < 120:
            sys.exit(0)

    result = fetch_usage(debug=debug)
    if result:
        with open(CACHE_FILE, 'w') as f:
            json.dump(result, f)
        print(f"Cached: {result}")
    else:
        print("Failed to get usage data")
