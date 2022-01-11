#!/usr/local/bin/python3

import requests
import sys
import re
import decompress
import json
import browser_cookie3

    

def main():
    print(len(sys.argv))
    if len(sys.argv) == 2:
        date = sys.argv[1]
    else:
        date = input("Enter date please(YYYY-MM-DD: ")

    y, m, d = date.split("-")
    url = f"https://www.nytimes.com/crosswords/game/daily/{y}/{m}/{d}"
    #cookie_file = "nytcookies.txt"
    #with open('cookietest.txt', 'w') as f:
    #    json.dump(requests.utils.dict_from_cookiejar(cookies), f)
    #with open(cookie_file, 'r') as f:
    #    cookies = requests.utils.cookiejar_from_dict(json.load(f))
    
    cookies = browser_cookie3.chrome(domain_name='nytimes.com')
    # Load the webpage, its inline javascript includes the puzzle data
    puzzleData = requests.get(url, cookies=cookies).content
    puzzleData = puzzleData.decode("utf-8")
    # Look for the javascript, it's easist here to just use a regex
    m = re.search("(pluribus|window.gameData) *= *['\"](?P<data>.*?)['\"]", puzzleData)
    # Pull out the data element
    puzzleData = m.group("data")
    # Which is url-encoded
    puzzleData = decompress.decode(puzzleData)
    # And LZString compressed
    puzzleData = decompress.decompress(puzzleData)
    # write to file
    with open("nytjson.json", 'w') as f:
        f.write(puzzleData)
    
    # get puzzle id from json
    respjson = json.loads(puzzleData)
    puzzid = respjson["gamePageData"]["meta"]["id"]
    
    pdfurl = f"https://www.nytimes.com/svc/crosswords/v2/puzzle/{puzzid}.pdf"
    pdfresp = requests.get(pdfurl, cookies=cookies)
    with open("nytimespdf.pdf", 'wb') as f:
        f.write(pdfresp.content)
    

if __name__ == "__main__":
    main()