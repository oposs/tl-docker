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
        id $tlu > /dev/null 2>&1  # Check if user already exists
        if [ $? -ne 0 ]; then
          useradd --create-home --shell=/bin/bash --password $(perl -e "print crypt(q{$tlp},$$)") $tlu
          echo "User created"
        else
          usermod --password $(perl -e "print crypt(q{$tlp},$$)") $tlu
          echo "User modifed"
        fi
        ;;
    add-ssh-user)
        tlu=$2
        tlk=$3
        if [ "x$tlk" = "x" ]; then
            echo "Expected:"
            echo "$0 $func <username> <public ssh key>"
            exit
        fi
        id $tlu > /dev/null 2>&1  # Check if user already exists
        if [ $? -ne 0 ]; then
           useradd -m $tlu        # Create user 
        fi
        HOMEDIR="`getent passwd $tlu | cut -d: -f6`" # Get home directory
        umask 0077
        if [ ! -d $HOMEDIR/.ssh ]; then
           mkdir -p $HOMEDIR/.ssh # Create .ssh directory
        fi
        echo "$tlk" >> $HOMEDIR/.ssh/authorized_keys # Add public key to authorized_keys
        chmod 0700 $HOMEDIR # Change permission
        chown -R $tlu:$tlu $HOMEDIR # Change owner 
        echo "User created with ssh-key"
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

docker exec my-demo-docker tlcfg add-ssh-user myuser "public ssh key"

docker exec my-demo-docker tlcfg set-hostname \$(hostname -f)

EOF
        ;;
esac
