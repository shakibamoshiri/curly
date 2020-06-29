
# __help function

function __help(){
    echo -e  " $0 help ...\n
definition:
 doing things in a 'curl' way ...

arguments:
 -h | --help        print this hel
 -c | --conf-file   path to configuration file
 -f | --ftp         check / mount / umount / upload / download
                        $(colorize 'cyan' 'check'): checking FTP connection
                        $(colorize 'cyan' 'mount'): mount over FTP
                        $(colorize 'cyan' 'umount'): umount: umount FTP mount point
                        $(colorize 'cyan' 'upload'): upload: upload to a FTP account
                        $(colorize 'cyan' 'download'): download: download from a FTP account
 -s | --ssl         valid / date
                        $(colorize 'cyan' 'valid'): checking if SSL of a domain is valid
                        $(colorize 'cyan' 'date'): check start and end date of the certificate
 -H | --http        status / redirect / gzip
                        $(colorize 'cyan' 'status'): print header for the GET request
                        $(colorize 'cyan' 'redirect'): check if redirect id done or not
                        $(colorize 'cyan' 'gzip'): check if gzip is enabled or not
 -c | --connection
 -m | --mount-point     path to a directory
 -l | --local-file      a single file for uploading over FTP
 -r | --remote-path     an absolute remote path for the FTP account
"
    exit 0;
}

