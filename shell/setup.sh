#!/bin/bash
pip3 install --user awsiotsdk
mkdir -p ~/environment/dummy_client/certs/
cd ~/environment/dummy_client/
wget https://awsj-iot-handson.s3-ap-northeast-1.amazonaws.com/aws-iot-core-workshop/dummy_client/device_main.py -O device_main.py
