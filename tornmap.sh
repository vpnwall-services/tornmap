#!/bin/bash

# Check if packages are installed
# Install them if not present
for package in nmap xsltproc tor proxychains
do
	if dpkg -s $package > /dev/null ; then echo -e "\n$package is installed";else echo -e "Installing $package";apt-get install $package -y > /dev/null;fi
done

# Configure proxychains config file
cat << EOF > $(pwd)/proxychains.conf
strict_chain
proxy_dns
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5 127.0.0.1 9050
EOF

# Check if service is started
if lsof -i :9050 > /dev/null; then echo "Tor is started";else service tor restart;fi
#lsof -i :9050

banner(){
clear
echo -e "\n------------------------"
echo -e "\n    TOR NMAP SCANNER"
echo -e "\nScan through Tor Network"
echo -e "\n------------------------"
echo -e "\n    Vpnwall Services"
echo -e "\n------------------------"
}

banner
echo -e "\nEnter ip address or domain name :"
VAR=$1
if [ -z $VAR ]
then
	clear
	banner
	echo -e "\nPlease input ip address or domain name and restart"
else
	echo -e "\nLet's scan ^^"
	#proxychains nmap -sT -Pn -n -sV -v -iR 500 -p 80 -oX /tmp/reportrand.scan
	proxychains nmap -sT -Pn -n -sV -v $VAR -oX /tmp/reports-$VAR.scan
	xsltproc /tmp/reports-$VAR -o /tmp/reports-$VAR.html
	#chmod 777 -R /tmp/reportrand.html
	echo "To view report, open /tmp/reports-$VAR.html"
fi
