#!/bin/bash

################################################################################
# Title: curly completion script
# Author: Shakiba Moshiri
# Date: 20XX
################################################################################

###
# long flags && short flags
###
curly_flags=($(egrep -o '\-\-[a-zA-Z0-9_]+' <(curly 2>&1)));
curly_flags_short=($(egrep -o '\-[A-Z0-9_]+' <(curly 2>&1)));

###
# list of actions
###
ftp_actions=(check upload download mount umount);
ssl_actions=(valid date cert name);
http_actions=(response redirect status ttfb gzip);
dns_actions=(root public trace);
ip_actions=(info port route);
email_actions=(send);
command_actions=(check install);

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
            COMPREPLY=( $(egrep -o '\bu[^ ]+\b' <<< ${ftp_actions[@]}) );
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
            COMPREPLY=( $(egrep -o 'r[^ ]+\b' <<< ${http_actions[@]}) );
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

comp_ip () {
    case $1 in
        i )
           COMPREPLY=(info);
        ;;
        p )
            COMPREPLY=(port);
        ;;
        r )
            COMPREPLY=(root);
        ;;
        [!ipr] )
            COMPREPLY=("# invalid action '$1' for ip");
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

comp_command () {
    case $1 in
        c | ch | che | chec )
            COMPREPLY=(check);
        ;;
        i | in | ins | inst | insta )
            COMPREPLY=(install);
        ;;
        [!ci] )
            COMPREPLY=("# invalid action '$1' for command");
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
        -I | --ip )
            COMPREPLY=(${ip_actions[@]})
            comp_ip ${CURRENT_FLAG};
        ;;
        -E | --email )
            COMPREPLY=(${email_actions[@]})
            comp_email ${CURRENT_FLAG};
        ;;
        -C | --command )
            COMPREPLY=(${command_actions[@]})
            comp_command ${CURRENT_FLAG};
        ;;
    esac

    case ${CURRENT_FLAG} in
        --f )
            COMPREPLY=( $(egrep -o '\-\-f[^ ]+\b' <<< ${curly_flags[@]}) );
        ;;
        --ft )
            COMPREPLY=(--ftp);
        ;;
        --fc | --fmp | --fr | --fl | --dc | -d | -h )
            COMPREPLY=(${CURRENT_FLAG});
        ;;
        -F | -S | -H | -D | -E | -I | -C )
            COMPREPLY=(${CURRENT_FLAG});
        ;;
        --fm )
            COMPREPLY=(--fmp)
        ;;
        --s )
            COMPREPLY=(--ssl)
        ;;
        --h )
            COMPREPLY=( $(egrep -o '\-\-h[^ ]+\b' <<< ${curly_flags[@]}) );
        ;;
        --ht )
            COMPREPLY=(--http);
        ;;
        --he )
            COMPREPLY=(--help)
        ;;
        --d )
            COMPREPLY=( $(egrep -o '\-\-d[^ ]+\b' <<< ${curly_flags[@]}) );
        ;;
        --dn )
            COMPREPLY=(--dns)
        ;;
        --do )
            COMPREPLY=(--domain)
        ;;
        --i )
            COMPREPLY=(--ip)
        ;;
        --e )
            COMPREPLY=(--email)
        ;;
        --c )
            COMPREPLY=(--command)
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

