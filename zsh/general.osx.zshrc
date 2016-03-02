# Add homebrew to the completion path
fpath=("/usr/local/bin/" $fpath)

# Add Go to Path
export GOPATH=$HOME/.Go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Colors for Cheat
export CHEATCOLORS=true

# General Assembly Stuff
# export EDITOR="subl -w -n"
export PAGER="less -f"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"

# Adds Dasht to path
export PATH=$PATH:/Users/Tim/Create/OtherGit/dasht/bin

# Add ~/dev to the cdpath
cdpath=(~/dev ~)
