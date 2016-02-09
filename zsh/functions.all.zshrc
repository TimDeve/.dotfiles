# Mkdir and cd
mkcd() { mkdir -p "$@" && cd "$_"; }

# cd & ls
cl() { cd "$@" && ls; }
