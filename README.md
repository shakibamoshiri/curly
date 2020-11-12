# curly
Speak `curl` for faster troubleshooting
[docs.redcursor.ir/tools/curly](https://docs.redcursor.ir/tools/curly);

## what is it?
**curly** is a bash CLI for faster and simpler troubleshooting.  
The workflow is based on **action** and **action-receiver**.  

### action-receiver
Here are some receivers  
1. FTP
2. SSL
3. HTTP
4. DNS
5. IP
6. Email 

and check receiver can deal with some actions e.g.  
1. check, mount, etc (for FTP)
2. valid, date, etc (for SSL)
4. root, trace, etc (for DNS)

This type is design a scalable and later we can add more features to our app with minimum code manipulation.

### Examples
Check the FTP connection
```bash
$ curly --ftp check --fc conf/dl.amozeshsabz.ir
drwx--x---   7 ftp      ftp          4096 Jul 26 14:06 .
drwx--x---   7 ftp      ftp          4096 Jul 26 14:06 ..
-rw-r--r--   1 ftp      ftp            18 Apr  1  2020 .bash_logout
-rw-r--r--   1 ftp      ftp           193 Apr  1  2020 .bash_profile
-rw-r--r--   1 ftp      ftp           231 Apr  1  2020 .bashrc
drwx--x--x   3 ftp      ftp          4096 Jul 13 11:26 domains
drwxrwx---   3 ftp      ftp          4096 Jul 13 11:26 imap
drwxrwx---   2 ftp      ftp          4096 Jul 13 11:26 Maildir
drwxrwx---   2 ftp      ftp          4096 Nov  9 00:17 .php
lrwxrwxrwx   1 ftp      ftp            42 Jul 13 11:26 public_html -> ./domains/pz11313.parspack.net/public_html
-rw-r-----   1 ftp      ftp            98 Jul 13 11:26 .shadow
-rw-r--r--   1 ftp      ftp            26 Jul 13 15:09 test-file.txt
drwx------   2 ftp      ftp          4096 Jul 13 11:26 tmp

option: ftp
action: check
status: OK
```

check SSL date 
```bash
$ curly --ssl date -d shakiba.net
Verify return code: 0 (ok)
from: Mon Aug 10 00:00:00 UTC 2020
till: Tue Aug 10 12:00:00 UTC 2021
days total:  364
days passed: 92
days left:   272

option: ssl
action: date
status: OK
```

check TTFB of a domain 
```bash
curly --http ttfb -d media.shakiba.net
url_effective       https://media.shakiba.net/
time_namelookupe    0.012499 | DNS lookup
time_connect        0.013454 | TCP connection
time_appconnect     0.049755 | App connection
time_redirect       0.005649 | Redirection time
time_starttransfer  0.057018 | TTFB
time_total          0.058207

option: http
action: ttfb
status: OK
```

check records of a domain and its root DNS server
```bash
curly --dns root -d derak.cloud
DNS server A.NIC.CLOUD
;derak.cloud.			IN	ANY
derak.cloud.		3600	IN	NS	4.top.derak.cloud.
derak.cloud.		3600	IN	NS	1.top.derak.cloud.
derak.cloud.		3600	IN	NS	2.top.derak.cloud.
derak.cloud.		3600	IN	NS	3.top.derak.cloud.
4.top.derak.cloud.	3600	IN	A	159.69.229.229
3.top.derak.cloud.	3600	IN	A	178.62.222.218
2.top.derak.cloud.	3600	IN	A	5.145.112.112
1.top.derak.cloud.	3600	IN	A	5.145.115.115

option: dns
action: root
status: OK
```
