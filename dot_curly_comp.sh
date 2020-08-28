#!/bin/bash


complete_flags () {
    COMPREPLY=('--ftp' '--ssl' '--http' '--dns' '--email');
    case ${COMP_WORDS[ $COMP_CWORD ]} in
        --f )
            COMPREPLY=('--ftp')
        ;;
        --s )
            COMPREPLY=('--ssl')
        ;;
        --h )
            COMPREPLY=('--http')
        ;;
        --d )
            COMPREPLY=('--dns')
        ;;
        --e )
            COMPREPLY=('--email')
        ;;
    esac
}

complete_ftp () {
    COMPREPLY=( 'check' 'upload' 'download' 'mount' 'umount' );
    case ${COMP_WORDS[$COMP_CWORD]} in
        u | up | upl )
            COMPREPLY=('upload')
        ;;
        c | ch | che )
            COMPREPLY=('check')
        ;;
        d | do | dow | down )
            COMPREPLY=('download')
        ;;
        m | mo | mon )
            COMPREPLY=('mount')
        ;;
        um | umo | umou)
            COMPREPLY=('umount')
        ;;
    esac
}

complete_ssl () {
    COMPREPLY=( 'valid' 'date' 'cert' 'name' );
    case ${COMP_WORDS[$COMP_CWORD]} in
        v )
            COMPREPLY=('valid')
        ;;
        d )
            COMPREPLY=('date')
        ;;
        c )
            COMPREPLY=('cert')
        ;;
        n )
            COMPREPLY=('name')
        ;;
    esac
}

complete_http () {
    COMPREPLY=('response' 'redirect' 'status' 'ttfb' 'gzip');
    case ${COMP_WORDS[$COMP_CWORD]} in
        res | resp )
            COMPREPLY=('response')
        ;;
        red | redir )
            COMPREPLY=('redirect')
        ;;
        s | st )
            COMPREPLY=('status')
        ;;
        t | tt )
            COMPREPLY=('ttfb')
        ;;
        g | gz )
            COMPREPLY=('gzip')
        ;;
    esac
}

complete_dsn () {
    COMPREPLY=('root' 'public' 'trace');
    case ${COMP_WORDS[ $COMP_CWORD ]} in
        r | ro )
            COMPREPLY=('root')
        ;;
        p | pu | pub )
            COMPREPLY=('public')
        ;;
        t | tr )
            COMPREPLY=('trace')
        ;;
    esac
}

curly_comp () {
    if [[ $COMP_CWORD < 3 ]]; then
        complete_flags;
        
        if [[ ${COMP_WORDS[$COMP_CWORD-1]} = '--ftp' ]]; then
            complete_ftp;
        fi

        if [[ ${COMP_WORDS[$COMP_CWORD-1]} = '--ssl' ]]; then
            complete_ssl;
        fi

        if [[ ${COMP_WORDS[$COMP_CWORD-1]} = '--http' ]]; then
            complete_http;
        fi

        if [[ ${COMP_WORDS[$COMP_CWORD-1]} = '--dns' ]]; then
            complete_dsn;
        fi
    # when there is no match fall back to default
    else
        # bash -4v
        # compopt -o nospace -o default -o bashdefault;
        # COMPREPLY=( $(compgen -S "/" -d "${COMP_WORDS[$COMP_CWORD]}") )
        
        # bash +4v
        compopt -o default;
        COMPREPLY=()
    fi
}

complete -o bashdefault -o default  -F curly_comp curly;
