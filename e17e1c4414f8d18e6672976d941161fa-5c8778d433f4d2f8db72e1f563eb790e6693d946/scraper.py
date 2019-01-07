# pylint: skip-file

import time
import re
import md5
import requests
import json


INSTAGRAM_URL = "https://www.instagram.com"
HASHTAG_ENDPOINT = "/graphql/query/?query_hash={}&variables={}"
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36"

def get_first_page(hashtag):
    return requests.get(INSTAGRAM_URL + "/explore/tags/{}/".format(hashtag), headers={"user-agent": USER_AGENT})

def get_csrf_token(cookies):
    return cookies.get("csrftoken")

def get_query_id(html):
    script_path = re.search(r'/static(.*)TagPageContainer\.js/(.*).js', html).group(0)
    script_req = requests.get(INSTAGRAM_URL + script_path)
    return re.findall('return e.tagMedia.byTagName.get\\(t\\).pagination},queryId:"([^"]*)"', script_req.text)[0]

def get_rhx_gis(html):
    return re.search(r'rhx_gis":"([^"]*)"', html).group(1)

def get_end_cursor_from_html(html):
    return re.search(r'end_cursor":"([^"]*)"', html).group(1)

def get_end_cursor_from_json(json_obj):
    return json_obj['data']['hashtag']['edge_hashtag_to_media']['page_info']['end_cursor']

def get_params(hashtag, end_cursor):
    return '{{"tag_name":"{}","first":50,"after":"{}"}}'.format(hashtag, end_cursor)

def get_ig_gis(rhx_gis, params):
    return md5.new(rhx_gis + ":" + params).hexdigest()

def get_posts_from_json(json_obj):
    edges = json_obj['hashtag']['edge_hashtag_to_media']['edges']
    return [o['node'] for o in edges]

def get_posts_from_html(html):
    json_str = re.search(r'window._sharedData = (.*);</script>', html).group(1)
    json_obj = json.loads(json_str)
    graphql = json_obj["entry_data"]["TagPage"][0]["graphql"]
    return get_posts_from_json(graphql)

def make_cookies(csrf_token):
    return {
        "ig_pr": "2",
        "csrftoken": csrf_token,
    }

def make_headers(ig_gis):
    return {
        "x-instagram-gis": ig_gis,
        "x-requested-with": "XMLHttpRequest",
        "user-agent": USER_AGENT
    }

def get_next_page(csrf_token, ig_gis, query_id, params):
    cookies = make_cookies(csrf_token)
    headers = make_headers(ig_gis)
    url = INSTAGRAM_URL + HASHTAG_ENDPOINT.format(query_id, params)
    req = requests.get(url, headers=headers, cookies=cookies)
    req.raise_for_status()
    json_obj = req.json()
    end_cursor = get_end_cursor_from_json(json_obj)
    posts = get_posts_from_json(json_obj['data'])
    return posts, end_cursor

def scrape_hashtag(hashtag, sleep=3):
    """
    Yields scraped posts, one by one
    """
    first_page = get_first_page(hashtag)
    csrf_token = get_csrf_token(first_page.cookies)
    query_id = get_query_id(first_page.text)
    rhx_gis = get_rhx_gis(first_page.text)
    end_cursor = get_end_cursor_from_html(first_page.text)
    home_posts = get_posts_from_html(first_page.text)

    for post in home_posts:
        yield post

    while end_cursor is not None:
        params = get_params(hashtag, end_cursor)
        ig_gis = get_ig_gis(rhx_gis, params)
        posts, end_cursor = get_next_page(csrf_token, ig_gis, query_id, params)
        for post in posts:
            yield post
        time.sleep(sleep)


# main
print get_rhx_gis('www.instagram.com')
    # do stuff
