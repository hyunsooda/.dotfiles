# Change default shell to ZSH
chsh -s $(which zsh)

# install fzf
git clone https://github.com/junegunn/fzf.git ~/.fzf && printf 'y\ny\ny\n' | ~/.fzf/install

# Install Oh My Zsh
printf 'y\n' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install Oh My Zsh Tools
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# install dotfiles
rm -f ~/.zshrc
git clone https://github.com/hyunsooda/config.git ~/.dotfiles
ln -s ~/.dotfiles/.vimrc                ~/.vimrc
ln -s ~/.dotfiles/.gitconfig            ~/.gitconfig
ln -s ~/.dotfiles/.gitconfig.common     ~/.gitconfig.common
ln -s ~/.dotfiles/.gitignore            ~/.gitignore
ln -s ~/.dotfiles/.tmux.conf            ~/.tmux.conf
ln -s ~/.dotfiles/.zshrc                ~/.zshrc
tmux new-session -s 123 -d && tmux source-file ~/.tmux.conf
zsh
