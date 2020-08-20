# curly
doing things in a 'curl' way ..

```bash
>>> curly
 /home/shu/bin/curly help ...

definition:
 doing things in a 'curl' way ...

arguments:
 -f | --ftp             some FTP actions ...
    |                   [1;36mcheck[0m: checking FTP connection
    |                   [1;36mmount[0m: mount over FTP
    |                   [1;36mumount[0m: umount: umount FTP mount point
    |                   [1;36mupload[0m: upload: upload to a FTP account
    |                   [1;36mdownload[0m: download: download from a FTP account

 -s | --ssl             some SSL actions ...
    |                   [1;36mvalid[0m: checking if SSL of a domain is valid
    |                   [1;36mdate[0m: check start and end date of the certificate
    |                   [1;36mcert[0m: show the certificate
    |                   [1;36mname[0m: name of domains the certificate issued for

 -H | --http            some HTTP actions ....
    |                   [1;36mresponse[0m: print response header of server
    |                   [1;36mredirect[0m: check if redirect id done or not
    |                   [1;36mstatus[0m: print status for the GET request
    |                   [1;36mttfb[0m: print statistics about Time to First Byte
    |                   [1;36mgzip[0m: check if gzip is enabled or not

 -D | --dns             some DNS actions ...
    |                   [1;36mroot[0m: check on root DNS servers
    |                   [1;36mpublic[0m: check on public DNS servers e.g 1.1.1.1
    |                   [1;36mtrace[0m: trace from a public DNS server to main server
    | --dns-server      a custom DNS server, default is: 1.1.1.1
    |                   or a file containing some DNS servers ( IPs | names )

 -E | --email           some DNS actions ...
    |                   [1;36msend[0m: send an email
    | --email-conf      configuration file for sending an email
    | --email-body      body (= contents) of the email that is send

 -h | --help            print this help
 -c | --conf-file       path to configuration file
 -m | --mount-point     path to a directory
 -l | --local-file      a single file for uploading over FTP
 -r | --remote-path     an absolute remote path for the FTP account
 -d | --domain          name of a domain, e.g. example.com

Copyright (C) 2020 Shakiba Moshiri
https://github.com/k-five/curly
```
