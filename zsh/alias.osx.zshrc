# Quick Look
alias qlf='qlmanage -p "$@" gt; /dev/null'

# Script to make Mac Update easy
alias masui="bash ~/dev/masui/masui"

# Airport utility
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# VLC
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# Midnight Commander exit in folder
alias mc=". /usr/local/Cellar/midnight-commander/4.8.14/libexec/mc/mc-wrapper.sh"

# cd to WDI folders
alias cdhw="cd /Users/Tim/dev/WDI_LDN_17_HOMEWORK/timDeve"
alias cdcw="cd /Users/Tim/dev/WDI_LDN_17_CLASSWORK"
alias cdln="cd /Users/Tim/dev/WDI_LDN_17_LESSON_NOTES"

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
