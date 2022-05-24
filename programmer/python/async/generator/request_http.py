import requests
import bs4


def main():
    urls = [
        'https://google.com',
        'https://pythonbyte.fm',
        'https://google.com',
        'https://realpython.com',
        'https://training.talkpython.fm/',


    ]


    for url in urls:
        print('Getting tittle from {}'.format(url.replace('https','')),end='....',flush=True)

        title = get_title(url)
        print("{}".format(title),flush=True) 
    
    print("Done",flush=True)



def get_title(url : str) -> str:
    print("==========",url,flush=True)
    headers = {"Content-Type", "application/json; charset=utf-8"}
    resp = requests.get(url,headers=headers)
    resp.raise_for_status()

    #html = resp.text()
    html = resp.text()

    soup = bs4.BeautifulSoup(html, features="html.parser")
    tag: bs4.Tag = soup.select_one('h1')
    
    if not tag:
        return None
    if not tag.text:
        a = tag.select_one('a')
        if a and a.text:
            return a.text
        elif a and 'title' in a.attrib:
            return a.attrs['title']
        else:
            return None
    return tag.get_text(strip=True)

if __name__ == '__main__':
    main()