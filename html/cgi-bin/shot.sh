#!/bin/sh
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

../../fbShot

echo "Content-type: text/html" # Tells the browser what kind of content to expect
echo "" # An empty line. Mandatory, if it is missed the page content will not load

#echo "<p><em>Hello World!</em></p>"
echo "<p><img src='http://$ip4/fb.bmp'/></p>" # 
