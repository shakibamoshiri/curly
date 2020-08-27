# curly
doing things in a 'curl' way ..

```bash
 /home/shu/bin/curly help ...

definition:
 doing things in a 'curl' way ...

arguments:
 -F | --ftp             FTP actions ...
    |                   check: checking FTP connection
    |                   mount: mount over FTP
    |                   umount: umount: umount FTP mount point
    |                   upload: upload: upload to a FTP account
    |                   download: download: download from a FTP account
    | --fc              ftp configuration file
    | --fmp             ftp mount point (local machine)
    | --fl              ftp local file for upload
    | --fr              ftp remote path

 -S | --ssl             SSL actions ...
    |                   valid: checking if SSL of a domain is valid
    |                   date: check start and end date of the certificate
    |                   cert: show the certificate
    |                   name: name of domains the certificate issued for

 -H | --http            HTTP actions ....
    |                   response: print response header of server
    |                   redirect: check if redirect id done or not
    |                   status: print status for the GET request
    |                   ttfb: print statistics about Time to First Byte
    |                   gzip: check if gzip is enabled or not

 -D | --dns             DNS actions ...
    |                   root: check on root DNS servers
    |                   public: check on public DNS servers e.g 1.1.1.1
    |                   trace: trace from a public DNS server to main server
    | --dc              dns servers to use, default is: 1.1.1.1
    |                   or a file containing some DNS servers ( IPs | names )

 -E | --email           Email actions ...
    |                   send: send an email
    | --ec              email configuration file for sending an email
    | --eb              email body (= contents) of the email that is send

 -h | --help            print this help
 -d | --domain          name of a domain, e.g. example.com

Copyright (C) 2020 Shakiba Moshiri
https://github.com/k-five/curly
```
