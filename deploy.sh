#!/bin/bash

# Deployment script for dooropenerpico
# By dwhweb 2024-05-14

project_root="$(dirname $(readlink -f "$0"))"

source $project_root/.githooks/write_config.sh

function read_config {
  read -p "Enter wifi SSID (name): " ssid
  read -p "Enter wifi password: " wifi_password
  read -p "Enter MQTT hostname/IP: " host
  read -e -p "Enter MQTT port (typically 1883): " -i 1883 port
  read -p "Enter MQTT username: " username
  read -p "Enter MQTT password: " mqtt_password
  write_config "/tmp/credentials.conf" "$ssid" "$wifi_password" "$host" "$port" "$username" "$mqtt_password"
}

if ! command -v rshell &> /dev/null; then
  echo "rshell is either not installed or not in your PATH, please see https://github.com/dhylands/rshell for installation instructions."
  exit 1
fi

while true; do
  read -p "This deployment script will ERASE the contents of your Pi Pico before deploying code, do you want to continue? (Yes/No): " yn
  case $yn in
    [Yy]* ) 
      echo "This may take a while while providing little console output, please be patient..."
      rshell rm -rf /pyboard/*\; cp "$project_root/main.py" /pyboard/main.py\; cp -r "$project_root/lib/" /pyboard/
      break;;
    [Nn]* ) exit 0; break;;
    * ) echo -e "Please answer yes or no.";;
  esac
done

while true; do
  read -p "Do you want to set up networking (Homeassistant with MQTT broker required)? (Yes/No): " yn
  case $yn in
    [Yy]* ) 
      read_config
      rshell cp /tmp/credentials.conf /pyboard/lib/dooropenerpico/credentials.conf
      rm /tmp/credentials.conf
      exit 0
      break;;
    [Nn]* ) 
      rshell rm -rf /pyboard/lib/dooropenerpico/credentials.conf
      exit 0
      break;;
    * ) echo -e "Please answer yes or no.";;
  esac
done
