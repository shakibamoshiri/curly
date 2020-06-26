#!/bin/bash


### set colors ###
_c_red="\x1b[1;31m";
_c_green="\x1b[1;32m";
_c_yellow="\x1b[1;33m";
_c_cyan="\x1b[1;36m";
_c_reset="\x1b[m";

function colorize(){
    case $1 in
        yellow )
            echo -e ${_c_yellow}$2${_c_reset};
        ;;
        green )
            echo -e ${_c_green}$2${_c_reset};
        ;;
        red )
            echo -e  ${_c_red}$2${_c_reset};
        ;;
        cyan )
            echo -e  ${_c_cyan}$2${_c_reset};
        ;;
    esac
}

function print_result(){
    echo -e "\noption: $2";
    echo "action:" $(colorize 'cyan'  $3);
    if [[ $1 == 0 ]]; then
        echo "status:" $(colorize 'green' 'done');
    else
        echo "status:" $(colorize 'red' 'ERROR');
    fi
}

_curl_path_=$(which curl);
_curlftpfs_path_=$(which curlftpfs);

if ! [[ -x $_curl_path_ ]]; then
    echo "ERROR ...";
    echo "the 'curl' program is required";
    echo "please install it";
    exit 1;
fi

if ! [[ -x $_curlftpfs_path_ ]]; then
    echo "ERROR ...";
    echo "the 'curlftpfs' program is required";
    echo "please install it";
    exit 1;
fi

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
"
    exit 0;
}

function __debug(){
    echo '######### DEBUG ##########';
    echo "conf-file $_conf_path_";
    echo "ftp $_ftp_";
    echo "mount-point $_mount_point_";
    echo 
    echo 
    echo -e "1. $_user_domain_ \n2. $_user_name_ \n3. $_user_pass_";
}

if [[ $1 == "" ]]; then
    __help;
fi


# read the options
ARGS=`getopt -o "hc:f:m:" -l "help,conf-file:,ftp:,mount-point:" -- "$@"`
eval set -- "$ARGS"

# global variable 
_conf_path_="";
_ftp_="";
_mount_point_="";


# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -h | --help )
            __help;
        ;;
        
        # configure file
        -c | --conf-file )
            _conf_path_=$2;

            # check if the file exist and it is readable
            if ! [[ -r $_conf_path_ ]]; then
                echo "ERROR ...";
                echo "file: $_conf_path_ does NOT exist!";
                exit 1;
            elif ! [[ -s $_conf_path_ ]]; then
                echo "WARNING ...";
                echo "file: $_conf_path_ is empty!";
                exit 0;
            fi
            shift 2;
        ;;
        
        # --ftp
        -f | --ftp )
            _ftp_=$2;
            case "$2" in
                check ) ;;
                mount )
                    if ! [[ "$@" =~ ' -m ' || "$@" =~ ' --mount-point ' ]]; then
                        echo "WARNING ...";
                        echo "With 'mount' ftp a 'mount-point' is required.";
                        echo "Use -m or --mount-point with a path.";
                        exit 2;
                    fi
                ;;
                umount )
                    if ! [[ "$@" =~ ' -m ' || "$@" =~ ' --mount-point ' ]]; then
                        echo "WARNING ...";
                        echo "With 'umount' ftp a 'mount-point' is required.";
                        echo "Use -m or --mount-point with a path.";
                        exit 2;
                    fi
                ;;

                upload ) ;;
                download ) ;;
                * )
                    echo "$@ is not a valid ftp";
                ;;
            esac
            shift 2;
        ;;

        # --mount-point
        -m | --mount-point )
            _mount_point_=$2;

            # check if the directory exist
            if ! [[ -d $_mount_point_ ]]; then
                echo "WARNING ...";
                echo "$_mount_point_ directory does NOT exist";
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
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Now take ftp

declare -a  _conf_file_=($(cat $_conf_path_));

# check if length of the array is 3
if [[ ${#_conf_file_[@]} != 3 ]]; then
    echo "WARNING ...";
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



case $_ftp_ in 
    check )
        curl --insecure --user "${_user_name_}:${_user_pass_}" ftp://${_user_domain_}/
        print_result $? 'ftp' 'check';
    ;;
    mount )
        curlftpfs "${_user_name_}:${_user_pass_}@${_user_domain_}" $_mount_point_
        print_result $? 'ftp' 'mount';
    ;;
    umount )
        sudo umount $_mount_point_;
        print_result $? 'ftp' 'umount';
        ;;
    upload )
    ;;
    download ) ;;
esac

