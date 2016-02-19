# Find everything
function finda () {
  find . -iname *$1*
}

# Convert Markdown to Word
function md2word () {
  pandoc -o $2 -f markdown -t docx $1
}


function dkmstart() {
  docker-machine start $1 && docker-machine env $1 && eval "$(docker-machine env $1)"
}

function dokku() {
  ssh root@do.timdeve.com "dokku $@"
}
