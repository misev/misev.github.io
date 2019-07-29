#!/bin/bash

prev_prefix=
prev_target=

for f in $(find $HOME/projects/misev.github.io/images/blog/iceland/ -name '*.jpg' | sed '/cover/d' | sort); do
    grep "$f" done && continue

    target_file=$(echo "$f" | sed 's|/iceland/|/iceland_abstract/|')
    prefix=$(echo "$target_file" | sed 's/.\.jpg//')

    fl=$(echo "$target_file" | sed 's/.\.jpg/l.jpg/')
    fm=$(echo "$target_file" | sed 's/.\.jpg/m.jpg/')
    fs=$(echo "$target_file" | sed 's/.\.jpg/s.jpg/')

    target_width=$(exiftool "$f" | grep Width | awk '{ print $4; }')
    echo "file $f, width: $target_width"

    echo -n "  finding source file for $f..."
    source_file="$fl"
    [ -f "$source_file" ] || source_file="$fm"
    [ -f "$source_file" ] || source_file="$fs"
    if [ ! -f "$source_file" ]; then
        cp "$f" "$target_file"
        source_file="$target_file"
    fi
    echo " $source_file"

    echo "  prefix: '$prefix', prev_prefix: '$prev_prefix'"
    if [ "$prefix" == "$prev_prefix" ]; then
        echo "  resizing previously generated $prev_target to $target_file"
        convert -resize $target_width "$prev_target" "target_file"
    else
        mode=4
        while [ $mode -eq 4 ]; do
            mode=$(shuf -i1-5 -n1)
        done
        echo "  generating $target_file, with mode $mode"
        primitive -i "$source_file" -o "$target_file" -n 200 -m $mode -s $target_width

        prev_prefix="$prefix"
        prev_target="$target_file"
    fi

    echo "$f" >> done
done
