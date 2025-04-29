#!/bin/bash

CSV="bank.csv"

if [ ! -f "$CSV" ]; then
    echo "Client,Sold curent" > "$CSV"
fi

afiseaza_meniu() {
    echo ""
    echo "=== Sistem Bancar ==="
    echo "1 - Adauga client nou"
    echo "2 - Modifica soldul"
    echo "3 - Șterge client"
    echo "4 - Afiseaza clientii"
    echo "Altceva - Iesire"
    echo -n "Optiune: "
}

adauga_client() {
    read -p "Nume client: " client
    if grep -q "^$client," "$CSV"; then
        echo "Clientul exista deja."
    else
        echo "$client,0" >> "$CSV"
        echo "Client adaugat cu succes."
    fi
}

modifica_sold() {
    read -p "Nume client: " client
    if grep -q "^$client," "$CSV"; then
        read -p "Sold nou: " sold
        tmp=$(mktemp)
        while IFS= read -r line; do
            if [[ "$line" == "$client,"* ]]; then
                echo "$client,$sold" >> "$tmp"
            else
                echo "$line" >> "$tmp"
            fi
        done < "$CSV"
        mv "$tmp" "$CSV"
        echo "Sold actualizat."
    else
        echo "Clientul nu exista."
    fi
}

sterge_client() {
    read -p "Nume client: " client
    if grep -q "^$client," "$CSV"; then
        grep -v "^$client," "$CSV" > temp_file && mv temp_file "$CSV"
        echo "Client sters."
    else
        echo "Clientul nu a fost gasit."
    fi
}

afiseaza_lista() {
    echo ""
    echo "--- Lista clienti ---"
    column -s, -t "$CSV"
}

while true; do
    afiseaza_meniu
    read opt
    case $opt in
        1) adauga_client ;;
        2) modifica_sold ;;
        3) sterge_client ;;
        4) afiseaza_lista ;;
        *) echo "La revedere!"; break ;;
    esac
done

