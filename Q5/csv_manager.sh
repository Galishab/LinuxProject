#!/bin/bash

CSV_FILE=""
LAST_OUTPUT="5_output.txt"

#
create_csv() {
    read -p "Enter new CSV file name: " CSV_FILE
    echo "Date collected,Species,Sex,Weight" > "$CSV_FILE"
    echo "Created CSV file: $CSV_FILE"
}


display_csv() {
    if [[ ! -f "$CSV_FILE" ]]; then
        echo "CSV file not found!"
        return
    fi
    awk 'BEGIN {FS=","} NR==1 {print "Index," $0; next} {print NR-1 "," $0}' "$CSV_FILE" | tee "$LAST_OUTPUT"
}


add_row() {
    if [[ ! -f "$CSV_FILE" ]]; then
        echo "CSV file not found!"
        return
    fi
    read -p "Enter Date collected (e.g. 1/8): " date_collected
    read -p "Enter Species (e.g. OT, PF, NA): " species
    read -p "Enter Sex (M/F): " sex
    read -p "Enter Weight: " weight
    echo "$date_collected,$species,$sex,$weight" >> "$CSV_FILE"
    echo "Added new row: $date_collected, $species, $sex, $weight"
}


filter_by_species() {
    if [[ ! -f "$CSV_FILE" ]]; then
        echo "CSV file not found!"
        return
    fi
    read -p "Enter species to filter (e.g. OT, PF): " species
    awk -v sp="$species" -F"," 'NR==1 {print $0; next} $2 == sp {print; sum+=$4; count++} END {if(count>0) print "Average Weight:", sum/count}' "$CSV_FILE" | tee "$LAST_OUTPUT"
}


filter_by_species_sex() {
    if [[ ! -f "$CSV_FILE" ]]; then
        echo "CSV file not found!"
        return
    fi
    read -p "Enter species (e.g. OT, PF): " species
    read -p "Enter sex (M/F): " sex
    awk -v sp="$species" -v s="$sex" -F"," 'NR==1 {print $0; next} $2 == sp && $3 == s {print}' "$CSV_FILE" | tee "$LAST_OUTPUT"
}


save_output() {
    if [[ ! -f "$LAST_OUTPUT" ]]; then
        echo "No last output found!"
        return
    fi
    read -p "Enter file name to save output (e.g. filtered_data.csv): " new_csv
    cp "$LAST_OUTPUT" "$new_csv"
    echo "Saved output to: $new_csv"
}


delete_row() {
    if [[ ! -f "$CSV_FILE" ]]; then
        echo "CSV file not found!"
        return
    fi
    display_csv
    read -p "Enter row index to delete: " row_index
    awk -v idx="$row_index" -F"," 'NR==1 {print; next} NR-1 != idx {print}' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    echo "Deleted row at index: $row_index"
}


update_weight() {
    if [[ ! -f "$CSV_FILE" ]]; then
        echo "CSV file not found!"
        return
    fi
    display_csv
    read -p "Enter row index to update: " row_index
    read -p "Enter new Weight value: " new_weight
    awk -v idx="$row_index" -v w="$new_weight" -F"," 'NR==1 {print; next} {if (NR-1 == idx) $4=w; print}' OFS="," "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    echo "Updated weight at row index: $row_index to $new_weight"
}


commit_and_push() {
    git add "$CSV_FILE" "$LAST_OUTPUT"
    git commit -m "Updated CSV data"
    git push origin master  
    echo "Changes committed and pushed to GitHub."
}


while true; do
    echo "----------------------------------"
    echo "CSV Manager - Choose an option:"
    echo "----------------------------------"
    echo "1) CREATE CSV by name"
    echo "2) Display all CSV data with row index"
    echo "3) Add new row from user input"
    echo "4) Filter by species + show average weight"
    echo "5) Filter by species + sex"
    echo "6) Save last output to new CSV file"
    echo "7) Delete row by row index"
    echo "8) Update weight by row index"
    echo "9) Commit & Push to GitHub"
    echo "10) Exit"
    echo "----------------------------------"
    read -p "Enter your choice: " choice

    case $choice in
        1) create_csv ;;
        2) display_csv ;;
        3) add_row ;;
        4) filter_by_species ;;
        5) filter_by_species_sex ;;
        6) save_output ;;
        7) delete_row ;;
        8) update_weight ;;
        9) commit_and_push ;;
        10) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
done
