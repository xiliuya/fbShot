#!/bin/sh

# defines
TARGETIP=192.168.2.19
OLDPROGRAMPATH_REMOTE=/root/fbShot
EXECUTABLE_REMOTE=/root/fbShot
EXECUTABLE_LOCAL=app/fbShot
PATH_REMOTE=/root
PATH_LOCAL=app/fbShot

# make the target
#make MOD=3

# kill gdbserver on target
ssh root@$TARGETIP mrw
ssh root@$TARGETIP killall gdbserver
ssh root@$TARGETIP killall fbShot

# remove old executable on target
ssh root@$TARGETIP rm $OLDPROGRAMPATH_REMOTE

# copy over new executable
scp -r $PATH_LOCAL root@$TARGETIP:$PATH_REMOTE
ssh root@$TARGETIP sync

# start gdb on target (IS ONE LONG COMMAND)#
ssh -n -f root@$TARGETIP "sh -c 'cd /root; /root/fbShot > /dev/null 2>&1 &'"

ssh root@$TARGETIP mro
