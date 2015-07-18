#!/bin/bash

file=./HERE\ Demo/Credentials.h
read -p "Enter HERE App ID: " appId
read -p "Enter HERE App Code: " appCode
sed -i '' "s/^.*APP_ID.*$/#define APP_ID @\"${appId}\"/" "${file}"
sed -i '' "s/^.*APP_CODE.*$/#define APP_CODE @\"${appCode}\"/" "${file}"
sed -i '' "s/^.*#error.*$//" "${file}"