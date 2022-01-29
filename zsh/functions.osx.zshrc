# Find everything
function finda () {
  find . -iname *$1*
}

# Convert Markdown to Word
function md2word () {
  pandoc -o $2 -f markdown -t docx $1
}

function timer() {

  case $2 in
    "h"*)
      time=time*3600
      echo $time
      ;;
    "m"*)
      time=time*60
      echo $time
      ;;
    "s"*)
      time=$1
      echo $time
      ;;
    *)
      echo "Unrecognized unit"
#      exit 1
  esac

  beep="bee"

  for (( i=1; i<=100; i++ ))
  do
     beep+=beep
  done

  sleep $time && say "$beep" -v "bells"

}

