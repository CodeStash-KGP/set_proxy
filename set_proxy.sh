#! /bin/sh
# A script to set system-wide proxy in Ubuntu / Debian
# created by thealphadollar

echo "Proxy Host:"; read PROXY_HOST
echo "Proxy Port:"; read PROXY_PORT

# setting system wide proxy
gsettings set org.gnome.system.proxy mode manual
gsettings set org.gnome.system.proxy.http host "$PROXY_HOST"
gsettings set org.gnome.system.proxy.http port "$PROXY_PORT"
gsettings set org.gnome.system.proxy.https host "$PROXY_HOST"
gsettings set org.gnome.system.proxy.https port "$PROXY_PORT"
gsettings set org.gnome.system.proxy.ftp host "$PROXY_HOST"
gsettings set org.gnome.system.proxy.ftp port "$PROXY_PORT"
gsettings set org.gnome.system.proxy.socks host "$PROXY_HOST"
gsettings set org.gnome.system.proxy.socks port "$PROXY_PORT"


# setting apt proxy

## in apt.conf
sudo sed -i.bak '/http[s]::proxy/Id' /etc/apt/apt.conf
sudo tee -a /etc/apt/apt.conf <<EOF
Acquire::http::proxy "http://${PROXY_HOST}:${PROXY_PORT}/";
Acquire::https::proxy "http://${PROXY_HOST}:${PROXY_PORT}/";
Acquire::ftp::Proxy "http://${PROXY_HOST}:${PROXY_PORT}/";
EOF

## in apt.conf.d/70debconf
sudo sed -i.bak '/http[s]::proxy/Id' /etc/apt/apt.conf.d/70debconf
sudo tee -a /etc/apt/apt.conf.d/70debconf <<EOF
Acquire::http::proxy "http://${PROXY_HOST}:${PROXY_PORT}/";
Acquire::https::proxy "http://${PROXY_HOST}:${PROXY_PORT}/";
Acquire::ftp
 {
   Proxy "ftp://${PROXY_HOST}:{PROXY_PORT}/";
   ProxyLogin
   {
      "USER $(SITE_USER)@$(SITE)";
      "PASS $(SITE_PASS)";
   }
 }
EOF


# setting environment proxy
sudo sed -i.bak '/http[s]_proxy/Id' /etc/environment
sudo tee -a /etc/environment <<EOF
http_proxy="http://${PROXY_HOST}:${PROXY_PORT}/"
https_proxy="http://${PROXY_HOST}:${PROXY_PORT}/"
ftp_proxy="http://${PROXY_HOST}:${PROXY_PORT}/"
HTTP_PROXY="http://${PROXY_HOST}:${PROXY_PORT}/"
HTTPS_PROXY="http://${PROXY_HOST}:${PROXY_PORT}/"
FTP_PROXY="http://${PROXY_HOST}:${PROXY_PORT}/"
no_proxy=127.0.0.0/8,::1,10.0.0.0/8
EOF


# proxy for profile
sudo touch /etc/profile.d/proxy.sh
sudo tee -a /etc/profile.d/proxy.sh <<EOF
export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export https_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export HTTP_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
export HTTPS_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
EOF
