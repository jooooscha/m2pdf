#!/bin/sh

convert() {
     markdown-pdf $name.md -s $css -f "A4"
     echo "updating pdf"
}

css=./default.css

file=false
edit=false
watch=false

while getopts "c:f:ewh" flag
do
  case "${flag}" in
    c) css="${OPTARG}";;
    f) name="${OPTARG::-3}"
       file=true;;
    e) edit=true;; 
    w) watch=true;;
    h) help=true;;
  esac
done


if [ "$help" = true ]; then
    echo "use -f for file, -c for a custom css file, -e to edit this script, -w to watch files changes."
elif [ "$edit" = true ]; then
    echo "opening script ..."
    (&>./scanmd.sh &)
else
    if [ "$file" = true ]
    then
        echo "cssfile used: $css"
        convert
        if [ "$watch" = true ]
        then
            echo "waiting for filechange ..."
            inotifywait -mrq -e create -e modify -e delete ./ --include *.md | while read file; do (convert) done
        fi
    else
        echo "Please provide a markdown file with -f"
    fi
fi


