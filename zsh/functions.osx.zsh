# Find everything
finda () {
  find . -iname *$1*
}

# Convert Markdown to Word
md2word () {
  pandoc -o $2 -f markdown -t docx $1
}

timer() {
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

notif() {
  osascript -e "display notification \"$*\" with title \"Terminal\""
}

with-notif() {
  local exit_code escaped result
  $*
  exit_code="$?"
  escaped="$(echo "$@" | sed 's/"/\\"/')"
  if [[ "$exit_code" = 0 ]]; then
    result="SUCCESS"
  else
    result="FAILURE"
  fi

  osascript -e "display notification \"$escaped\" with title \"$result\""
  return "$exit_code"
}
