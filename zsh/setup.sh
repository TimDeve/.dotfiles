mv ~/.zshrc ~/.zshrc.bak
ln -s ~/.dotfiles/zsh/zshrc.zgen ~/.zshrc
touch ~/.dotfiles/zsh/secrets.zshrc
git clone https://github.com/tarjoilija/zgen ~/.zgen/zgen
