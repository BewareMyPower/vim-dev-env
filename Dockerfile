FROM ubuntu:18.04

RUN apt update
RUN apt install -y software-properties-common gcc g++ curl git \
    clang-format clang-format-5.0 cmake wget ctags python3

# Build vim 8.1 from source, python3 support and ctags are required by LeaderF
WORKDIR /root
RUN apt install -y make lib32ncurses5-dev python3-dev
RUN git clone https://github.com/vim/vim.git -b v8.2.4724 \
    && cd vim && LDFLAGS=-rdynamic ./configure --enable-python3interp --with-python3-command=python3 \
    && make -j4 && make install && cd .. && rm -rf vim

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY .vimrc /root
COPY coc-settings.json /root/.vim

# Node.js is required for coc.nvim
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs

# Clone vim plugins manually because it's impossible to run `vim -c PlugInstalled` in Dockerfile
WORKDIR /root/.vim/plugged
RUN git clone https://github.com/skywind3000/asyncrun.vim.git
RUN git clone https://github.com/neoclide/coc.nvim.git -b release
RUN git clone https://github.com/Yggdroot/LeaderF.git
RUN git clone https://github.com/preservim/nerdtree.git
RUN git clone https://github.com/mhinz/vim-signify.git
RUN git clone https://github.com/vim-scripts/a.vim.git
RUN git clone https://github.com/vim-airline/vim-airline.git
RUN git clone https://github.com/vim-airline/vim-airline-themes.git

# Build ccls for C++ completion
WORKDIR /root
RUN apt install -y zlib1g-dev
RUN wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz \
    && tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
RUN git clone --depth=1 --recursive https://github.com/MaskRay/ccls && cd ccls \
    && cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/root/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 \
    && cmake --build Release -- -j4 && cp Release/ccls /usr/bin \
    && cd .. && rm -rf rm -rf ccls/ clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04/
