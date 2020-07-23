# curly
doing things in a 'curl' way ..

```bash
definition:
 doing things in a 'curl' way ...

arguments:
 -f | --ftp         check / mount / umount / upload ...
                        check: checking FTP connection
                        mount: mount over FTP
                        umount: umount: umount FTP mount point
                        upload: upload: upload to a FTP account
                        download: download: download from a FTP account
 -s | --ssl         valid / date / cert / name ...
                        valid: checking if SSL of a domain is valid
                        date: check start and end date of the certificate
                        cert: show the certificate
                        name: name of domains the certificate issued for
 -H | --http        response /  status / redirect / ttfb ...
                        response: print response header of server
                        redirect: check if redirect id done or not
                        status: print status for the GET request
                        ttfb: print statistics about Time to First Byte
                        gzip: check if gzip is enabled or not

 -h | --help            print this help
 -c | --conf-file       path to configuration file
 -m | --mount-point     path to a directory
 -l | --local-file      a single file for uploading over FTP
 -r | --remote-path     an absolute remote path for the FTP account
 -d | --domain          name of a domain, e.g. example.com

Copyright (C) 2020 Shakiba Moshiri
https://github.com/k-five/curly
```
