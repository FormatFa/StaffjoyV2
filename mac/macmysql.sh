#!/bin/bash

set -e
HOST=127.0.0.1
PORT=56066
echo "MySQL UP - Initializing databases"

# account-mysql-service
mysql -u root -pSHIBBOLETH -h $HOST -p  $PORT -e "create database account"
mysql -u root -pSHIBBOLETH -h $HOST -p $PORT -e "create database company"
