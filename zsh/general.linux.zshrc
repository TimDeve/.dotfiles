# Export path for perl bin
export PATH="/usr/bin/core_perl:$PATH"

# Ruby path
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
