#!/bin/bash

declare -A results

for dir in "./Testcase"*; do
    [[ "$dir" == *"Diff" ]] && continue
    diff_path="${dir#./}Diff"
    key="${dir#./}"      # moved up here, out of the inner loop
    anydiff=0

    for path in "$dir"/"Version"*".1.txt"; do
        major="${path%.*.txt}"
        major="${major#$dir/Version}"

        minor_1="$dir/Version$major.1.txt"
        minor_2="$dir/Version$major.2.txt"
        diff_file_name="$diff_path"/Version"$major"Diff.txt

        diff=$(diff -u "$minor_1" "$minor_2")

        if [[ -z "$diff" ]]; then
            if [[ -e "$diff_file_name" ]]; then
                results["$key"]="FAIL"
                continue 2
            fi
        else
            anydiff=1
            if [[ ! -f "$diff_file_name" ]] || \
               [[ "$(tail -n +3 <<< "$diff")" != "$(tail -n +3 "$diff_file_name")" ]]; then
                results["$key"]="FAIL"
                continue 2
            fi
        fi
    done

    if [[ $anydiff -eq 1 && -d "$diff_path" ]] || [[ $anydiff -eq 0 && ! -d "$diff_path" ]]; then
        results["$key"]="PASS"
    else
        results["$key"]="FAIL"
    fi
done

success="PASS"

while IFS= read -r key; do
    val="${results[$key]}"
    if [[ $val == "FAIL" ]]; then
        success="FAIL"
    fi
    echo "$key": "$val"
done < <(printf "%s\n" "${!results[@]}" | sort)

if [[ $success == "FAIL" ]]; then
    exit 1
fi
