#!/bin/sh
# thinlinc config helper
func=$1
case $func in
    add-user)
        tlu=$2
        tlp=$3
        if [ x$tlp = x ]; then
            echo "Expected:"
            echo "$0 $func <username> <password>"
            exit
        fi
        useradd --password $(perl -e "print crypt(q{$tlp},$$)") $tlu
        echo "User created"
        ;;
    set-hostname)
        tlh=$2
        if [ x$tlh = x ]; then
            echo "Expected:"
            echo "$0 $func <hostname>"
            exit
        fi
        /opt/thinlinc/bin/tl-config   /vsmagent/agent_hostname=$tlh
        systemctl restart vsmagent
        echo "Hostname set to $tlh"
        ;;
    *)
        cat <<EOF
ThinLinc Testdrive Config Interface
-----------------------------------

Before you can test thinlinc you have to create a user and
set the hostname, your instance will be visible under. Normally
this might be the hostname of the machine where you are running docker.

docker exec my-demo-docker tlcfg add-user myuser mypassword

docker exec my-demo-docker tlcfg set-hostname \$(hostname -f)

EOF
        ;;
esac