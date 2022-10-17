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
$SUDO $APT install -y curl git gcc g++ cmake clang-format nodejs universal-ctags

if [[ $PROXY ]]; then
    git config --global http.https://github.com.proxy $PROXY
fi

# ccls required Node.js 14.14.0 or higher
curl -O -L https://install-node.vercel.app/lts
$SUDO bash lts -y
rm -f lts

if [[ $BUILD_LATEST_CCLS ]]; then
    git clone --depth=1 --recursive https://github.com/MaskRay/ccls
    cd ccls
    $SUDO $APT install -y clang libclang-dev
    cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=/usr/lib/llvm-10 \
        -DLLVM_INCLUDE_DIR=/usr/lib/llvm-10/include \
        -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-10/
    cmake --build Release -j8
else
    $SUDO $APT install -y ccls
fi

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
        git clone https://github.com/zivyangll/git-blame.vim.git
    popd

    cp -f .vimrc ~/.vimrc
    cp -f coc-settings.json ~/.vim
popd
