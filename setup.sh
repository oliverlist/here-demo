#!/bin/bash

workspace=./HERE\ Demo.xcworkspace
pods=./Pods
if [ ! -d $pods ]
then
	echo "Running pod install"
	pod install	
fi
./credentials.sh
if [ -e "${workspace}" ]
then
	open -a Xcode.app "${worksapce}"
else
	echo "workspace "${workspace}" not found"
fi