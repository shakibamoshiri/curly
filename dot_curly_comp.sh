#!/bin/bash

################################################################################
# Title: curly completion script
# Author: Shakiba Moshiri
# Date: 20XX
################################################################################

###
# long flags && short flags
###
curly_flags=(--{ftp,ssl,dns,http,email,fc,fmp,fr,fl,dc,domain,help});
curly_flags_short=(-{F,S,H,D,E,h,d});

###
# list of actions
###
ftp_actions=(check upload download mount umount);
ssl_actions=(valid date cert name);
http_actions=(response redirect status ttfb gzip);
dns_actions=(root public trace);
email_actions=(send);

################################################################################
# function for completing actions
################################################################################
comp_ftp () {
    case $1 in
        c )
            COMPREPLY=(check);
        ;;
        up )
            COMPREPLY=(upload);
        ;;
        d )
            COMPREPLY=(download);
        ;;
        m )
            COMPREPLY=(mount);
        ;;
        um )
            COMPREPLY=(umount);
        ;;
        u )
            COMPREPLY=( $(echo ${ftp_actions[@]} | egrep -o '\bu[^ ]+\b') );
        ;;
        [!cudm] )
            COMPREPLY=("# invalid action '$1' for FTP");
        ;;
    esac
}

comp_ssl () {
    case $1 in
        v )
            COMPREPLY=(valid);
        ;;
        d )
            COMPREPLY=(date);
        ;;
        c )
            COMPREPLY=(cert);
        ;;
        n )
            COMPREPLY=(name);
        ;;
        [!vdcn] )
            COMPREPLY=("# invalid action '$1' for SSL");
        ;;
    esac
}

comp_http () {
    case $1 in
        r | re )
            COMPREPLY=( $(echo ${http_actions[@]} | egrep -o 'r[^ ]+\b') );
        ;;
        res )
            COMPREPLY=(response);
        ;;
        red )
            COMPREPLY=(redirect);
        ;;
        s )
            COMPREPLY=(status)
        ;;
        t )
            COMPREPLY=(ttfb);
        ;;
        g )
            COMPREPLY=(gzip);
        ;;

        [!rtg])
            COMPREPLY=("# invalid action '$1' for HTTP");
        ;;
    esac
}

comp_dns () {
    case $1 in
        r )
            COMPREPLY=(root);
        ;;
        p )
            COMPREPLY=(public);
        ;;
        t )
            COMPREPLY=(trace);
        ;;
        [!rpt] )
            COMPREPLY=("# invalid action '$1' for DNS");
        ;;
    esac
}

comp_email () {
    case $1 in
        s )
            COMPREPLY=(send);
        ;;
        [!s] )
            COMPREPLY=("# invalid action '$1' for Email");
        ;;
    esac
}


################################################################################
# main function which invoked by "complete -F"
################################################################################
comp () {
    CURRENT_FLAG=${COMP_WORDS[$COMP_CWORD]};
    PERVIOU_FLAG=${COMP_WORDS[$COMP_CWORD-1]};

    # COMPREPLY=();
    case ${COMP_WORDS[$COMP_CWORD-1]} in
        -F | --ftp )
            COMPREPLY=(${ftp_actions[@]})
            comp_ftp ${CURRENT_FLAG};
        ;;
        -S | --ssl )
            COMPREPLY=(${ssl_actions[@]})
            comp_ssl ${CURRENT_FLAG};
        ;;
        -H | --http )
            COMPREPLY=(${http_actions[@]})
            comp_http ${CURRENT_FLAG};
        ;;
        -D | --dns )
            COMPREPLY=(${dns_actions[@]})
            comp_dns ${CURRENT_FLAG};
        ;;
        -E | --email )
            COMPREPLY=(${email_actions[@]})
            comp_email ${CURRENT_FLAG};
        ;;
    esac

    case ${CURRENT_FLAG} in
        --f )
            COMPREPLY=( $(echo ${curly_flags[*]} | egrep -o '\-\-f[^ ]+\b') );
        ;;
        --ft )
            COMPREPLY=(--ftp);
        ;;
        --fc | --fmp | --fr | --fl | --dc | -d | -h )
            COMPREPLY=(${CURRENT_FLAG});
        ;;
        -F | -S | -H | -D | -E )
            COMPREPLY=(${CURRENT_FLAG});
        ;;
        --fm )
            COMPREPLY=(--fmp)
        ;;
        --s )
            COMPREPLY=(--ssl)
        ;;
        --h )
            COMPREPLY=( $(echo ${curly_flags[@]} | egrep -o '\-\-h[^ ]+\b') );
        ;;
        --ht )
            COMPREPLY=(--http);
        ;;
        --he )
            COMPREPLY=(--help)
        ;;
        --d )
            COMPREPLY=( $(echo ${curly_flags[@]} | egrep -o '\-\-d[^ ]+\b') );
        ;;
        --dn )
            COMPREPLY=(--dns)
        ;;
        --do )
            COMPREPLY=(--domain)
        ;;
        --e )
            COMPREPLY=(--emaill)
        ;;
        - )
            COMPREPLY=(${curly_flags_short[@]})
        ;;
        -- )
            COMPREPLY=(${curly_flags[@]})
        ;;
        --[A-Z] )
            COMPREPLY=("# invalid name '$CURRENT_FLAG' for -- long options");
        ;;
    esac
}

complete -o bashdefault -o nosort  -o default -F comp curly

