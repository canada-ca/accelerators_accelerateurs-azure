#!/bin/bash

echo "running post linux install...."
#echo "joining domain..."
#may need different commands to domain join each release
#See https://bitsofwater.com/2018/05/08/join-ubuntu-18-04-to-active-directory/

#net ads join -S $1 -U $2'%'$3
#sudo realm join --verbose --user=$2 --computer-ou=OU=Linux,DC=pspc,DC=gc,DC=ca,DC=local pspc.gc.ca.local
#net ads join -U $2'%'$3