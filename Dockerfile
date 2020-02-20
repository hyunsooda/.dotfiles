FROM ubuntu:18.04
MAINTAINER hyunsooda

ENV HOME /root/hyunsoo
RUN mkdir /home/.dotfiles

RUN \
    apt-get update && \
    apt-get -y install \
			software-properties-common \
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
            zsh \
            ocaml \
            wget

# latest golang install
RUN add-apt-repository -y ppa:longsleep/golang-backports && \
	apt-get -y install \
			golang-go

# Install m4, autoconf and automake
WORKDIR $HOME
RUN wget http://ftp.gnu.org/gnu/m4/m4-1.4.17.tar.gz
RUN wget ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
RUN wget ftp://ftp.gnu.org/gnu/automake/automake-1.9.tar.gz

RUN tar xvfz m4-1.4.17.tar.gz
RUN tar xvfz autoconf-2.69.tar.gz
RUN tar xvfz automake-1.9.tar.gz

WORKDIR $HOME/m4-1.4.17
RUN ./configure --prefix=/usr && make && make install
WORKDIR $HOME/autoconf-2.69
RUN ./configure --prefix=/usr && make && make install
WORKDIR $HOME/automake-1.9
RUN ./configure --prefix=/usr && make && make install

# Change default shell to ZSH
RUN chsh -s $(which zsh)

# install fzf
RUN git clone https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install Oh My Zsh Tools
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# install dotfiles
RUN git clone https://github.com/hyunsooda/config.git ~/.dotfiles
RUN \
    ln -s ~/.dotfiles/.vimrc                ~/.vimrc && \
    ln -s ~/.dotfiles/.gitconfig            ~/.gitconfig && \
    ln -s ~/.dotfiles/.gitconfig.common     ~/.gitconfig.common && \
    ln -s ~/.dotfiles/.gitignore            ~/.gitignore && \
    ln -s ~/.dotfiles/.tmux.conf            ~/.tmux.conf && \
    mv ~/.dotfiles/.zshrc                   ~/.zshrc && \
    tmux new-session -s 123 -d && tmux source-file ~/.tmux.conf && \
    zsh
