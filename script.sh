#!/bin/bash

for dir in "./Testcase"*; do
    if [[ $dir == *Diff ]]; then
        continue
    fi
    rm -rf "${dir#./}Diff"
    for path in "$dir"/"Version"*".1.txt"; do
        major="${path%.*.txt}"
        major="${major#$dir/Version}"

        minor_1="$dir/Version$major.1.txt"
        minor_2="$dir/Version$major.2.txt"

        diff=$(diff -u "$minor_1" "$minor_2")

        if ! [ -z "$diff" ]; then
            diff_path="${dir#./}"Diff
            if ! [ -d "$diff_path" ]; then
                mkdir "$diff_path"
            fi

            diff_file_name="$diff_path"/Version"$major"Diff.txt
            echo "$diff" > "$diff_file_name"
        fi
    done
done
