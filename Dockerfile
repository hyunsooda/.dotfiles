FROM ubuntu:18.04
MAINTAINER hyunsooda

RUN mkdir /home/.dotfiles
RUN \
    apt-get update && \
    apt-get -y install \
            vim \
            git \
            tmux \
            ctags \
            gcc \
            g++ \
            silversearcher-ag\
            valgrind \
            curl \
            make \
            golang-go

# install fzf
RUN git clone https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# install dotfiles
RUN git clone https://github.com/hyunsooda/config.git ~/.dotfiles
RUN \
    ln -s ~/.dotfiles/.vimrc                ~/.vimrc && \
    ln -s ~/.dotfiles/.gitconfig            ~/.gitconfig && \
    ln -s ~/.dotfiles/.gitconfig.common     ~/.gitconfig.common && \
    ln -s ~/.dotfiles/.gitignore            ~/.gitignore
