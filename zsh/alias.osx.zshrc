# Quick Look
alias qlf='qlmanage -p "$@" gt; /dev/null'

# Script to make Mac Update easy
alias masui="bash ~/dev/masui/masui"

# Airport utility
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# VLC
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# Copy Current Path
alias copp="pwd | pbcopy"

# Docker
alias dkm="docker-machine"
alias dkmstop="docker-machine stop"

# CD to dev
alias cdev="cd ~/dev"
alias cdevgo="cd ~/dev/go/src/github.com/timdeve"

# Alias to jo (json making utility)
alias jo="/Users/Tim/dev/OtherGit/jo/jo"

# ansiweather
alias we="ansiweather -a false -l"
alias we5="ansiweather -a false -F -l"
alias wel="ansiweather -a false -l london"
alias wel5="ansiweather -a false -F -l london"

# Pretty Git diff
alias gdiff="git diff --color | diff-highlight | diff-so-fancy"

# Redis
alias redis="redis-server /usr/local/etc/redis.conf"

# Find Gateway
alias findgate="netstat -nr | grep '^default'"

# Other cask alias
alias caskr="brew cask reinstall"
