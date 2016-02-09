# Find everything
function finda () {
  find . -iname *$1*
}

# Convert Markdown to Word
function md2word () {
  pandoc -o $2 -f markdown -t docx $1
}