# Add homebrew to the completion path
fpath=("/usr/local/bin/" $fpath)

# Add Go to Path
export GOPATH=$HOME/dev/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Colors for Cheat
export CHEATCOLORS=true

# Adds Dasht to path
export PATH=$PATH:~/dev/OtherGit/dasht/bin

# Add ~/dev to the cdpath
cdpath=(~/dev ~)

# Drupal Env
export DRUPAL_ENV_NAME="development"

# Add Composer to path
export PATH=~/.composer/vendor/bin:$PATH
