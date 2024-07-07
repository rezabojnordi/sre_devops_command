
import os

link = "\'https://ww" "w.filimo.com/w/o1veb""\'"

str = (f"curl -v {link} -H \'accept: */*"
   "\' -H \'accept-encod"
   "ing: gzip, deflate, "
   "br\' -H \'accept-lan"
   "guage: en-US,en;q=0."
   "9\' -H \'cookie: is_"
   "pwa=no; __auc=3d6432"
   "8517d9a0c77f9475c724"
   "a; _ym_d=1638967049;"
   " _ym_uid=16389670495"
   "74187746; tracker_ym"
   "_id=1638967049574187"
   "746; tracker_ga_id=4"
   "12755762.1638967049;"
   " footer-bigscreen=1;"
   " AuthV1=eyJ0eXAiOiJK"
   "V1QiLCJhbGciOiJIUzI1"
   "NiJ9.eyJpYXQiOjE2Mzg"
   "5NjcyNzcsImFmY24iOiI"
   "xNjM4OTY3MDQ5OTQxNTE"
   "iLCJzdWIiOiJEN0VBRjl"
   "DNi05MzRDLTM1QTgtMzJ"
   "FNC00MTI5NkU4ODgwRkE"
   "iLCJ0b2tlbiI6IjdmYjd"
   "jYWNlMGI1N2EwNTUyYjh"
   "iMWYyY2ZhN2I0YTVmIn0"
   ".a7DcbYZTSuhYOb7rLzP"
   "M6TkMUOFEGgqTmlLHhnB"
   "9j7U; __asc=35c1c07b"
   "17dd3760431af7cb5db;"
   " _gid=GA1.2.14162185"
   "74.1639930268; _ym_i"
   "sad=2; crisp-client%"
   "2Fsession%2F2c28528d"
   "-5b67-4812-90ea-d6ea"
   "0d510334=session_1a4"
   "3303d-1fe7-4519-ad81"
   "-499eca9a3cd9; track"
   "erAbTest=%5B%5D; _ga"
   "t_UA-153829-34=1; _g"
   "a_Y43NRD378Z=GS1.1.1"
   "639930267.7.1.163993"
   "2052.0; _ga=GA1.2.41"
   "2755762.1638967049\'"
   " -H \'referer: https"
   "://www.filimo.com/w/"
   "o1veb\' -H \'sec-ch-"
   "ua: \" Not A;Brand\""
   ";v=\"99\", \"Chromiu"
   "m\";v=\"96\", \"Goog"
   "le Chrome\";v=\"96\""
   "\' -H \'sec-ch-ua-mo"
   "bile: ?0\' -H \'sec-"
   "ch-ua-platform: \"Wi"
   "ndows\"\' -H \'sec-f"
   "etch-dest: empty\' -"
   "H \'sec-fetch-mode: "
   "cors\' -H \'sec-fetc"
   "h-site: same-origin"
   "\' -H \'user-agent: "
   "Mozilla/5.0 (Windows"
   " NT 6.3; Win64; x64)"
   " AppleWebKit/537.36 "
   "(KHTML, like Gecko) "
   "Chrome/96.0.4664.110"
   " Safari/537.36\' --c"
   "ompressed");
# print(str)
stream = os.popen(str)
output = stream.readlines()

# print(output)


file1 = open("myfile.txt","w")
L = output
file1.writelines(L)
file1.close()
  