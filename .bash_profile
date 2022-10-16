if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi

PROXY_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
alias sudop="sudo http_proxy=socks5h://$PROXY_IP:10808"
export https_proxy=socks5://$PROXY_IP:10808

git config --global http.https://github.com.proxy socks5://$PROXY_IP:10808

SSH_PROXY="ProxyCommand nc -x $PROXY_IP:10808 %h %p"
if [[ -f ~/.ssh/config ]]; then
    sed -i.bak "s/ProxyCommand nc -x.*/$SSH_PROXY/" ~/.ssh/config
else
    echo $SSH_PROXY > ~/.ssh/config
fi
