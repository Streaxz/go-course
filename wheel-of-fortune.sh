#!/bin/bash
hidden_word=""
guessed_word=""
tries=3

output=""

header="-------- Поле Чудес! -------- \n\n"
description="\n\nДобро пожаловать в игру! \n Вам предстоит разгадать загадку, зашифрованную в слове. \nВы можете использовать буквы для отгадывания слова. \nУ вас есть $tries попыток. \n"
print_types="\nВыберите что вы хотите сделать: \n\n1. Отгадать букву \n2. Отгадать слово \n"

initialize_game() {
    if [ -z "$1" ] || [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "Необходимо указать слово для игры (не число и не пустая строка)"
        exit 1
    else
        hidden_word="$1"
    fi

    for (( i=0; i < ${#hidden_word}; i++ )); do
        if [ $i -eq 0 ]; then
            guessed_word="*"
        else
            guessed_word="$guessed_word *"
        fi
    done

    echo -e "$header$description"
}

play_game() {
    while [ $tries -gt 0 ]; do
        output="$header"
        echo -e "$output"
        echo "Загаданное слово: $guessed_word"
        echo "Осталось попыток: $tries"
        echo " "
        read -p "$print_types" choice

        case $choice in
            "1")
                read -p "\nВведите букву: " letter
                if [[ ! "$letter" =~ ^[a-zA-Zа-яА-Я]{1}$ ]]; then
                    echo "Пожалуйста, введите одну букву."
                    continue
                fi

                if [[ "${guessed_word}" =~ "${letter,,}" ]]; then
                    echo "Вы уже угадали эту букву."
                    continue
                fi

                found=false
                new_guessed_word=""
                for (( i=0; i < ${#hidden_word}; i++ )); do
                    current_char="${hidden_word:$i:1}"
                    if [[ "${current_char,,}" == "${letter,,}" ]]; then
                        new_guessed_word="$new_guessed_word$current_char"
                        found=true
                    else
                        # Берем текущее состояние из guessed_word
                        if [ $i -eq 0 ]; then
                            current_guessed="${guessed_word:0:1}"
                        else
                            current_guessed="${guessed_word:$((i*2)):1}"
                        fi
                        if [[ "$current_guessed" == "*" ]]; then
                            new_guessed_word="$new_guessed_word*"
                        else
                            new_guessed_word="$new_guessed_word$current_guessed"
                        fi
                    fi
                    
                    # Добавляем пробел между буквами (кроме последней)
                    if [ $i -lt $((${#hidden_word}-1)) ]; then
                        new_guessed_word="$new_guessed_word "
                    fi
                done

                guessed_word="$new_guessed_word"

                if ! $found; then
                    output="$output\nНеправильно!"
                    tries=$(($tries - 1))
                else
                    output="$output\nПравильно!"
                fi

                if [[ "$guessed_word" == *"*"* ]]; then
                    echo "Слово еще не угадано полностью."
                else
                    echo "\n\nПоздравляем! Вы угадали слово: $hidden_word\n\n"
                    break
                fi
            ;;
            "2")
                read -p "\nВведите слово: " word
                if [ "$word" == "$hidden_word" ]; then
                    echo "\nВы угадали слово!"
                    break
                else
                    tries=$((tries - 1))
                    output="$output\nВы не угадали слово! У вас осталось $tries попыток."
                fi
            ;;
            *)
                echo "Неверный выбор! Пожалуйста, выберите 1 или 2."
            ;;
        esac
        clear
    done

    if [ "$guessed_word" != "$hidden_word" ]; then
        echo -e "\nВы проиграли! Загаданное слово было: $hidden_word"
    else
        echo -e "\nВы выиграли! Загаданное слово было: $hidden_word"
    fi
}

main() {
    initialize_game "$1"
    play_game
}

main "$1"