#!/bin/bash

declare -A results

for dir in "./Testcase"*; do
    for path in "$dir"/"Version"*".1.txt"; do
        major="${path%.*.txt}"
        major="${major#$dir/Version}"

        minor_1="$dir/Version$major.1.txt"
        minor_2="$dir/Version$major.2.txt"

        diff=$(diff -u "$minor_1" "$minor_2")

        if [ -z "$diff" ]; then
            results["$dir"]="PASS"
        else
            results["$dir"]="FAIL"
            diff_path="${dir#./}"Diff
            if ! [ -d "$diff_path" ]; then
                mkdir "$diff_path"
            fi

            diff_file_name="$diff_path"/Version"$major"Diff.txt
            echo $diff > "$diff_file_name"
        fi
    done
done

for result in $results; do
    if result == "FAIL"; then
        exit 1
    fi
done
