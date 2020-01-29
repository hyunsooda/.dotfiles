FROM ubuntu:18.04
MAINTAINER hyunsooda

ENV HOME /root/hyunsoo
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
            zsh \
            golang-go

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

