#!/bin/bash
###
# Author : Shakiba Moshiri
###

################################################################################
# an associative array for storing color and a function for colorizing
################################################################################
declare -A _colors_;
_colors_[ 'red' ]='\x1b[1;31m';
_colors_[ 'green' ]='\x1b[1;32m';
_colors_[ 'yellow' ]='\x1b[1;33m';
_colors_[ 'cyan' ]='\x1b[1;36m';
_colors_[ 'reset' ]='\x1b[0m';

function colorize(){
    if [[ ${_colors_[ $1 ]} ]]; then
        echo -e "${_colors_[ $1 ]}$2${_colors_[ 'reset' ]}";
    else
        echo 'wrong color name!';
    fi
}

################################################################################
# __help function
################################################################################
function __help(){
    echo -e  " $0 help ...\n
definition:
 doing things in a 'curl' way ...

arguments:
 -f | --ftp             some FTP actions ...
    |                   $(colorize 'cyan' 'check'): checking FTP connection
    |                   $(colorize 'cyan' 'mount'): mount over FTP
    |                   $(colorize 'cyan' 'umount'): umount: umount FTP mount point
    |                   $(colorize 'cyan' 'upload'): upload: upload to a FTP account
    |                   $(colorize 'cyan' 'download'): download: download from a FTP account

 -s | --ssl             some SSL actions ...
    |                   $(colorize 'cyan' 'valid'): checking if SSL of a domain is valid
    |                   $(colorize 'cyan' 'date'): check start and end date of the certificate
    |                   $(colorize 'cyan' 'cert'): show the certificate
    |                   $(colorize 'cyan' 'name'): name of domains the certificate issued for

 -H | --http            some HTTP actions ....
    |                   $(colorize 'cyan' 'response'): print response header of server
    |                   $(colorize 'cyan' 'redirect'): check if redirect id done or not
    |                   $(colorize 'cyan' 'status'): print status for the GET request
    |                   $(colorize 'cyan' 'ttfb'): print statistics about Time to First Byte
    |                   $(colorize 'cyan' 'gzip'): check if gzip is enabled or not
                        
 -D | --dns             some DNS actions ...
    |                   $(colorize 'cyan' 'root'): check on root DNS servers
    |                   $(colorize 'cyan' 'public'): check on public DNS servers e.g 1.1.1.1
    |                   $(colorize 'cyan' 'trace'): trace from a public DNS server to main server
    | --dns-server      a custom DNS server, default is: 1.1.1.1
    |                   or a file containing some DNS servers ( IPs | names )

 -h | --help            print this help
 -c | --conf-file       path to configuration file
 -m | --mount-point     path to a directory
 -l | --local-file      a single file for uploading over FTP
 -r | --remote-path     an absolute remote path for the FTP account
 -d | --domain          name of a domain, e.g. example.com

Copyright (C) 2020 Shakiba Moshiri
https://github.com/k-five/curly "
    exit 0;
}

################################################################################
# __debug function
################################################################################
function __debug(){
    echo '######### DEBUG ##########';
    echo "conf-file $_conf_path_";
    echo "ftp ${FTP['action']}";
    echo "mount-point ${FTP['mount_point']}";
    echo
    echo
    echo -e "1. $_user_domain_ \n2. $_user_name_ \n3. $_user_pass_";
}

################################################################################
# print the result of each action
################################################################################
function print_result(){
    echo -e "\noption: $2" >&2;
    echo "action:" $(colorize 'cyan'  $3) >&2;
    if [[ $1 == 0 ]]; then
        echo "status:" $(colorize 'green' 'OK') >&2;
    else
        echo "status:" $(colorize 'red' 'ERROR') >&2;
    fi
}

################################################################################
# check for required commands
# curl, curlftpfs
# grep, sed
# nmap, perl
################################################################################
declare -A _cmds_;
_cmds_['curl']=$(which curl);
_cmds_['curlftpfs']=$(which curlftpfs);
_cmds_['perl']=$(which perl);
_cmds_['nmap']=$(which nmap);

for cmd in ${_cmds_[@]}; do
    if ! [[ -x $cmd ]]; then
        echo "ERROR ...";
        echo "the $cmd is required";
        echo "please install it";
        exit 1;
    fi
done

################################################################################
# if there is no flags, prints help
################################################################################
if [[ $1 == "" ]]; then
    __help;
fi


################################################################################
# main flags, both longs and shorts
################################################################################
ARGS=`getopt -o "hc:f:s:H:D:m:l:r:d:" -l "help,conf-file:,ftp:,ssl:,http:,dns:,dns-server:,mount-point:,local-file:,remote-path:,domain:" -- "$@"`
eval set -- "$ARGS"

################################################################################
# global variable 
################################################################################
_conf_path_="";

declare -a _conf_file_;

# variables for FTP
declare -A FTP;
FTP['flag']=0;
FTP['action']='';
FTP['conf_path']='';
FTP['local_file']='';
FTP['mount_point']='';
FTP['remote_path']='';

# variables for SSL
declare -A ssl;
declare -A ssl_action;
ssl['flag']=0;
ssl['action']='';
ssl['domain']='';

# variables for HTTP
declare -A http;
http['flag']=0;
http['action']='';
http['domain']='';

declare -A dns;
dns['flag']=0;
dns['action']='';
dns['domain']='';
dns['server']='1.1.1.1';


################################################################################
# parse configuration file and assigns values to variables
################################################################################
function check_conf_path(){
    # check if the file exist and it is readable
    if ! [[ -r ${FTP['conf_path']} ]]; then
        echo "$(colorize 'red' 'ERROR' ) ...";
        echo "file: $_conf_path_ does NOT exist!";
        exit 1;
    elif ! [[ -s ${FTP['conf_path']} ]]; then
        echo "$(colorize 'yellow' 'WARNING' ) ...";
        echo "file: $_conf_path_ is empty!";
        exit 0;
    fi

    _conf_file_=($(cat ${FTP['conf_path']}));
    # check if length of the array is 3
    if [[ ${#_conf_file_[@]} != 3 ]]; then
        echo "$(colorize 'yellow' 'WARNING') ...";
        echo "conf-file format is NOT valid or some lines are missed!";
        echo -e "\nRight format ...";
        echo "example.com  # should be a domain name or an IP address";
        echo "username     # should be the username";
        echo "12345        # should be the password for that username";
        exit 2;
    fi

    _user_domain_=${_conf_file_[0]};
    _user_name_=${_conf_file_[1]};
    _user_pass_=${_conf_file_[2]};

}

################################################################################
# extract options and their arguments into variables.
################################################################################
while true ; do
    case "$1" in
        -h | --help )
            __help;
        ;;
        
        # configure file
        -c | --conf-file )
            FTP['conf_path']=$2;
            check_conf_path
            shift 2;
        ;;
        
        # --ftp
        -f | --ftp )
            FTP['flag']=1;
            FTP['action']=$2;
            case "$2" in
                check )
                ;;

                mount )
                ;;

                umount )
                ;;

                upload )
                ;;

                download )
                ;;
            esac
            shift 2;
        ;;

        -s | --ssl )
            ssl['flag']=1;
            ssl['action']=$2;
            case $2 in
                valid )
                ;;

                date )
                ;;
            esac
            shift 2;
        ;;

        -H | --http )
            http['flag']=1;
            http['action']=$2;
            shift 2;
        ;;

        -D | --dns )
            dns['flag']=1;
            dns['action']=$2;
            shift 2;
        ;;
        --dns-server )
            dns['server']=$2;
            shift 2;
        ;;

        # --mount-point
        -m | --mount-point )
            FTP['mount_point']=$2;

            # check if the directory exist
            if ! [[ -d ${FTP['mount_point']} ]]; then
                echo "$(colorize 'yellow' 'WARNING' ) ...";
                echo  "${FTP['mount_point']} directory does NOT exist";
                read -p "Do you want to create it? ( yes | no ) " _mount_point_creation_;
                case $_mount_point_creation_ in
                    y | yes )
                        echo "trying to create $_mount_point_creation_";
                    ;;
                    n | no )
                        echo "program exited because there is not directory to be mounted";
                        exit 1;
                    ;;
                    * )
                        echo "A mount point is required!";
                        exit 1;
                    ;;
                esac
            fi
            shift 2;
        ;;

        ## -l or --local-file
        -l | --local-file )
            FTP['local_file']=$2
            shift 2;
        ;;

        #
        -r | --remote-path )
            FTP['remote_path']=$2;
            shift 2;
        ;;

        -d | --domain )
           ssl['domain']=$2;
           http['domain']=$2;
           dns['domain']=$2;
           shift 2;
        ;;

        # last line
         --)
            shift;
            break;
         ;;

         *) echo "Internal error!" ; exit 1 ;;
    esac
done



################################################################################
# check and run FTP actions
################################################################################
if [[ ${FTP['flag']} == 1 ]]; then
    if [[ ${FTP['conf_path']} == '' && ${FTP['action']} != 'umount' ]]; then
        echo "$(colorize 'red' 'ERROR') ...";
        echo "The configuration file is required with ${FTP['action']} action.";
        echo "Use '-c' or '--conf-file' and give it a path to configuration file name.";
        exit 2;
    fi

    case ${FTP['action']} in 
        check )
            curl --insecure --user "${_user_name_}:${_user_pass_}" ftp://${_user_domain_}/${FTP['remote_path']}/;
            print_result $? 'ftp' 'check';
        ;;

        mount )
           if [[ ${FTP['mount_point']} == '' ]]; then
                echo "$(colorize 'yellow' 'WARNING' ) ...";
                echo "With 'mount' ftp a 'mount-point' is required.";
                echo "Use -m or --mount-point with a path.";
                exit 2;
            fi

            curlftpfs "${_user_name_}:${_user_pass_}@${_user_domain_}" ${FTP['mount_point']}
            print_result $? 'ftp' 'mount';
        ;;

        umount )
            if [[ ${FTP['mount_point']} == '' ]]; then
                echo "$(colorize 'yellow' 'WARNING' ) ...";
                echo "With 'umount' ftp a 'mount-point' is required.";
                echo "Use -m or --mount-point with a path.";
                exit 2;
            fi

            sudo umount ${FTP['mount_point']}
            print_result $? 'ftp' 'umount';
        ;;

        upload )
            if [[ $flag_local_file == 0 ]]; then
                echo "$(colorize 'yellow' 'WARNING') ...";
                echo "A file is required with 'upload' action";
                echo "Use '-l' or '--local-file' and give it a single file name";
                exit 2;
            fi

            curl  --insecure --user "${_user_name_}:${_user_pass_}" ftp://${_user_domain_}/${FTP['remote_path']}/ -T "${FTP['local_file']}";
            print_result $? 'ftp' 'upload';
        ;;

        download )
            if [[ ${FTP['remote_path']} == '' ]]; then
                echo "$(colorize 'red' 'ERROR') ...";
                echo "Absolute path to the remote file is required!.";
                echo "Use '-r' or '--remote-path with a given file name.'.";
                exit 2;
            fi

            curl --insecure --user "${_user_name_}:${_user_pass_}" ftp://${_user_domain_}/${FTP['remote_path']};
            print_result $? 'ftp' 'download';
        ;;

        * )
            echo "$(colorize 'yellow' 'WARNING') ...";
            echo "Action ${FTP['action']} is not supported";
            echo "Use '-h' or '--help' to see the available action for ftp.";
            exit 1;
        ;;
    esac
fi

################################################################################
# check and run SSL actions
################################################################################
if [[ ${ssl['flag']} == 1 ]]; then
    if [[ ${ssl['domain']} == '' ]]; then
        echo "$(colorize 'red' 'ERROR') ...";
        echo "A domain name is required!.";
        echo "Use '-d' or '--domain' with a given name.";
        exit 2;
    fi

    case ${ssl['action']} in
        valid )
            command_output=$(curl -vI https://${ssl['domain']} 2>&1 | grep -A 6 '* Server');
            if [[ $? != 0 ]]; then
                echo "${ssl['domain']} does not have a valid certificate."
                exit 0;
            fi
            echo "$command_output" | sed 's/^\* \+//g';
            print_result $? 'ssl' 'valid';
        ;;

        date )
            command_output=$(curl -vI https://${ssl['domain']} 2>&1 | grep -A 6 '* Server' | grep date);
            if [[ $? != 0 ]]; then
                echo "${ssl['domain']} does not have a valid certificate.";
                exit 0;
            fi
            echo "$command_output" | sed 's/^\* \+//g' | sed 's/start date:/start date: /'

            ssl_date=$(echo "$command_output" | sed 's/^[^A-Z]\+ //g');
            ssl_start=$(echo "$ssl_date" | head -n 1);
            ssl_end=$(echo "$ssl_date" | tail -n -1);

            ssl_start_sec=$(date -u --date="$ssl_start" "+%s");
            ssl_end_sec=$(date -u --date="$ssl_end" "+%s");

            today_sec=$(date "+%s");
            one_day=$(( 24 * 60 * 60 ));

            days_passed=$(( $(( $today_sec - $ssl_start_sec  )) / $one_day ));
            days_left=$(( $(( $ssl_end_sec -  $today_sec  )) / $one_day ));
            days_total=$(( $days_passed + $days_left ));

            echo "days passed: $days_passed";
            echo "days left:   $days_left";
            echo "days total:  $days_total";

            print_result $? 'ssl' 'date';
        ;;

        cert )
            command_output=$(nmap --script ssl-cert -v1  -p 443 ${ssl['domain']} | sed 's/|[ _]//g' | perl -lne '$/=null; /-----BEGIN.*CERTIFICATE-----/sg && print $&');
            if [[ $? != 0 ]]; then
                echo "${ssl['domain']} does not have a valid certificate.";
                exit 0;
            fi
            echo "$command_output";
            print_result $? 'ssl' 'cert';
        ;;

        name )
            command_output=$(nmap --script ssl-cert -v1  -p 443 ${ssl['domain']} | sed 's/|[ _]//g' | perl -lne '$/=null; /-----BEGIN.*CERTIFICATE-----/sg && print $&');
            echo "$command_output" | openssl x509  -text -noout  | grep DNS | tr ',' '\n' | sed 's/^ \+DNS://g'
            if [[ $? != 0 ]]; then
                echo "${ssl['domain']} does not have a valid certificate.";
                exit 0;
            fi
            print_result $? 'ssl' 'name';
        ;;

        * )
            echo "$(colorize 'yellow' 'WARNING') ...";
            echo "Action ${ssl['action']} is not supported";
            echo "Use '-h' or '--help' to see the available action for ssl.";
            exit 1;
        ;;
    esac
fi

################################################################################
# check and run http actions
################################################################################
if [[ ${http['flag']} == 1 ]]; then
    if [[ ${http['domain']} == '' ]]; then
        echo "$(colorize 'red' 'ERROR') ...";
        echo "A domain name is required!.";
        echo "Use '-d' or '--domain with a given name'.";
        exit 2;
    fi

    case ${http['action']} in
        res | respon | response )
            curl -LI ${http['domain']}
            print_result $? 'http' 'response';
        ;;

        st | stat | status )
            curl -sLo /dev/null -w \
'URL               %{url_effective}
status            %{http_code}
remote_ip         %{remote_ip}
remote_port       %{remote_port}
num_connects      %{num_connects}
num_redirects     %{num_redirects}
scheme            %{scheme}
http_version      %{http_version}
ssl_verify_result %{ssl_verify_result}
' ${http['domain']};
            print_result $? 'http' 'status';
        ;;

        red | redir | redirect )
            curl -LI ${http['domain']} 2>&1 | grep  -e HTTP -e [lL]ocation
            print_result $? 'http' 'redirect';
        ;;

        gz | gzip )
            curl -sLH 'Accept-Encoding: gzip' ${http['domain']} -o /tmp/curl.gz;
            gzip -l /tmp/curl.gz
            if [[ $? == 0 ]]; then
                echo 'gzip is enabled';
            else
                echo 'gzip is NOT enabled';
            fi
            print_result $? 'http' 'gzip';
        ;;

        tt | tt | ttfb )
            curl -sLo /dev/null -w \
'url_effective       %{url_effective}
time_namelookupe    %{time_namelookup} | DNS lookup
time_connect        %{time_connect} | TCP connection
time_appconnect     %{time_appconnect} | App connection
time_redirect       %{time_redirect} | Redirection time
time_starttransfer  %{time_starttransfer} | TTFB
time_total          %{time_total}
' ${http['domain']};
            print_result $? 'http' 'ttfb';
        ;;

        * )
            echo "$(colorize 'yellow' 'WARNING') ...";
            echo "Action ${http['action']} is not supported";
            echo "Use '-h' or '--help' to see the available action for ssl.";
            exit 1;
        ;;
    esac
fi

if [[ ${dns['flag']} == 1 ]]; then
    if [[ ${dns['domain']} == '' ]]; then
        echo "$(colorize 'red' 'ERROR') ...";
        echo "A domain name is required!.";
        echo "Use '-d' or '--domain with a given name'.";
        exit 2;
    fi

    case ${dns['action']} in
        ro | root )
            echo ${dns['domain']} | perl -lne '/(?<=\.).*?$/ && print $&' | xargs -I xxx whois xxx | grep nserver | awk '{print $2}' | xargs -I xxx dig ANY ${dns['domain']}  @xxx;
        ;;

        pub | public )
            # if it is a file
            if [[ -r ${dns['server']} ]]; then
                if ! [[ -s ${dns['server']} ]]; then
                    echo "$(colorize 'yellow' 'WARNING' ) ...";
                    echo "file: ${dns['server']} is empty!";
                    echo 'falling back to default: 1.1.1.1';
                    exit 2;
                fi
                xargs -I xxx dig ${dns['domain']} ANY @xxx < ${dns['server']};
            # if it is NOT a file
            else
                dig ${dns['domain']} A @${dns['server']};
            fi
        ;;

        tra | trace )
            dig +trace ${dns['domain']} @${dns['server']};
        ;;

        * )
            echo "$(colorize 'yellow' 'WARNING') ...";
            echo "Action ${dns['action']} is not supported";
            echo "Use '-h' or '--help' to see the available action for dns.";
            exit 1;
        ;;

    esac
    
fi
