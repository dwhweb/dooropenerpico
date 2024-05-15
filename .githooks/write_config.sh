function write_config {
cat > "$1" << EOL
{
  "ssid" : "$2",
  "wifi_password" : "$3",
  "host" : "$4",
  "port" : $5, 
  "username" : "$6",
  "mqtt_password" : "$7"
}
EOL
}
