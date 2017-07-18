mv ~/.zshrc ~/.zshrc.bak
ln -s ~/.dotfiles/zsh/zshrc.zgen ~/.zshrc
touch ~/.dotfiles/zsh/localpre.zshrc
touch ~/.dotfiles/zsh/localpost.zshrc
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
git clone https://github.com/tarjoilija/zgen ~/.zgen/zgen
