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

### Rust LSP (requirements)
- Vim version > 8.1.1719
- Install `coc-rust-analyzer` via (`:CocInstall coc-rust-analyzer`)
- Install `rust-analyzer` binary
- `coc-settings.json` (confiugrable with `:CocConfig`)
- vim configuration

### C/C++ LSP
- Compilation database generate tool(`bear`) is required for `make` base project.
