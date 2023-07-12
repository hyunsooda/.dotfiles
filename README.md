# Environment

#### Configs
- gitconfigs
- gitignore
- tmux.conf
- vimrc
- zshrc
- Dockerfile
- ctags_setup
- starship
- fusuma
- polybar
- kime

#### Setup dev-only
- `./dev-setup.sh`

#### Apt Mirror
- `./apt-mirror-kakao.sh`
- Error Reference: https://askubuntu.com/questions/760896/how-can-i-fix-apt-error-w-target-packages-is-configured-multiple-times

### Rust LSP (Troubble shoutting)
With the enable of `rust-analyzier` LSP, annoying syntax highlight turned on.
To disable it, refer to [this](https://github.com/simrat39/rust-tools.nvim/issues/365)


### C/C++ LSP
- Compilation database generate tool(`bear`) is required for `make` base project.
