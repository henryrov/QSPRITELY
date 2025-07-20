#!/bin/bash

echo "#ifndef SPRITES_H" > sprites.h
echo "#define SPRITES_H" >> sprites.h
echo "" >> sprites.h

sprites=()
sprites_i=0

for filename in "$@"; do
    spritename="sprite_${filename:0:$(( ${#filename}-4))}"
    sprites["${sprites_i}"]="${spritename}"
    sprites_i="$((${sprites_i}+1))"
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

    echo "static char ${spritename}[8] =" >> sprites.h
    echo "{" >> sprites.h
    
    for (( i=0; i<8; i++ )); do
        byte_strings[$i]="${byte_strings[$i]},"
        echo "${byte_strings[$i]}" >> sprites.h
    done

    echo "};" >> sprites.h
    echo "" >> sprites.h
done

echo "enum sprites_e" >> sprites.h
echo "{" >> sprites.h

for (( i=0; i<sprites_i; i++ )); do
    echo "  ${sprites[$((i))]^^}," >> sprites.h
done

echo "};" >> sprites.h
echo "" >> sprites.h

echo "extern char *sprites[];" >> sprites.h

echo "" >> sprites.h
echo "#endif" >> sprites.h

# Define sprites array in sprites.c

echo "#include \"sprites.h\"" > sprites.c
echo "" >> sprites.c

echo "char *sprites[] =" >> sprites.c
echo "{" >> sprites.c

for (( i=0; i<sprites_i; i++ )); do
    echo "  ${sprites[$((i))]}," >> sprites.c
done

echo "};" >> sprites.c

