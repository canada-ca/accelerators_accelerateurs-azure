#!/bin/sh
echo "bootscript initiated" > /tmp/results.txt

echo "Installing docker ..."
sudo snap install docker
echo "Waiting 10 seconds for docker to start ..."
sleep 10
echo "Loading container pmorjan/demo"
sudo docker run -d -p 80:80 --name ccc-landing patheard/ccc-landing:latest

echo "bootscript done" >> /tmp/results.txt

exit 0