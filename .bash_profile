if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi

###############################################################################
# Proxy related
###############################################################################
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

###############################################################################
# Git related
###############################################################################
pb() {
    git push origin $(git branch | grep "\*" | awk '{print $2}')
}

gp() {
    git pull
}

gd() {
    git diff
}

gdc() {
    git diff --cached
}

gs() {
    git show
}

gl() {
    git log
}

glo() {
    git log --pretty=oneline
}

function isWinDir {
    case $PWD/ in
        /c/* ) return $(true);;
        /d/* ) return $(true);;
        * ) return $(false);;
    esac
}

function git {
    if isWinDir
    then
        git.exe "$@"
    else
        /usr/bin/git "$@"
    fi
}
