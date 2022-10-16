#!/bin/bash
set -ex
cd ~

if [[ $USER != "" && $USER != "root" ]]; then
    SUDO=sudo
fi

if [[ $PROXY ]]; then
    export https_proxy=$PROXY
fi

if [[ $APT_PROXY ]]; then
    APT="http_proxy=$APT_PROXY apt"
else
    APT="apt"
fi

$SUDO $APT -y update
$SUDO $APT install -y curl git gcc g++ cmake clang-format ccls nodejs universal-ctags

if [[ $PROXY ]]; then
    git config --global http.https://github.com.proxy $PROXY
fi

# ccls required Node.js 14.14.0 or higher
curl -O -L https://install-node.vercel.app/lts
$SUDO bash lts -y
rm -f lts

$SUDO $APT install -y libncurses-dev python3-dev
git clone https://github.com/vim/vim.git -b v9.0.0713
pushd vim
    LDFLAGS=-rdynamic ./configure --enable-python3interp --with-python3-command=python3
    make -j4
    $SUDO make install
popd

git clone https://github.com/BewareMyPower/vim-dev-env.git
pushd vim-dev-env
    cp .vimrc ~/.vimrc
    
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    
    mkdir -p ~/.vim/plugged
    pushd ~/.vim/plugged
        git clone https://github.com/skywind3000/asyncrun.vim.git
        git clone https://github.com/neoclide/coc.nvim.git -b release
        git clone https://github.com/Yggdroot/LeaderF.git
        git clone https://github.com/preservim/nerdtree.git
        git clone https://github.com/mhinz/vim-signify.git
        git clone https://github.com/vim-scripts/a.vim.git
        git clone https://github.com/vim-airline/vim-airline.git
        git clone https://github.com/vim-airline/vim-airline-themes.git
        git clone https://github.com/bfrg/vim-cpp-modern.git
    popd

    cp -f .vimrc ~/.vimrc
    cp -f coc-settings.json ~/.vim

    # It seems that vim or sed cannot remove '\r' in a CRLF file.
    # This program is to achieve that goal.
    g++ -std=c++11 ./crlf_to_lf.cc -o ./crlf_to_lf
    $SUDO mv crlf_to_lf /usr/bin/crlf_to_lf
popd
