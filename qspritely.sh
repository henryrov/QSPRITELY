#!/bin/bash

> sprites.h

for filename in "$@"; do
    in_string=$(hexdump -v -e '/1 "%u\n"' "${filename}")
    byte_strings=()
    for (( i=0; i<8; i++ )); do
        byte_strings[$i]="  0b"
    done
    
    bit_number=0
    bit_line=1  

    while read line; do
        if [ "${bit_line}" -eq 1 ]; then  
            if [ "$line" -eq 0 ]; then
                byte_strings[$((${bit_number} % 8))]="${byte_strings[$((${bit_number}%8))]}0"
            else
                byte_strings[$((${bit_number} % 8))]="${byte_strings[$((${bit_number}%8))]}1"
            fi
            bit_line=0
            bit_number=$(("${bit_number}"+1))
        else
            bit_line=1
        fi
    done <<< "${in_string}"

    echo "static char sprite_${filename:0:$(( ${#filename}-4))}[8] =" >> sprites.h
    echo "{" >> sprites.h
    
    for (( i=0; i<8; i++ )); do
        byte_strings[$i]="${byte_strings[$i]},"
        echo "${byte_strings[$i]}" >> sprites.h
    done

    echo "};" >> sprites.h
    echo "" >> sprites.h
done
