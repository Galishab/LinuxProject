#!/bin/bash


if [ -z "$1" ]; then
  echo "Usage: $0 ~/Linux_Course_Work/Q4/plants_data.csv"
  exit 1
fi

CSV_FILE="$1"


mkdir -p ~/venvs
if [ ! -d ~/venvs/DEVBOX_Q4 ]; then
  python3 -m venv ~/venvs/DEVBOX_Q4
fi

source ~/venvs/DEVBOX_Q4/bin/activate


pip install --upgrade pip
pip install matplotlib


cd ~/Linux_Course_Work/Q4



tail -n +2 "$CSV_FILE" | while IFS=',' read -r PLANT HEIGHT LEAF_COUNT DRY_WEIGHT
do
  PLANT=$(echo "$PLANT" | sed 's/"//g')
  HEIGHT=$(echo "$HEIGHT" | sed 's/"//g')
  LEAF_COUNT=$(echo "$LEAF_COUNT" | sed 's/"//g')
  DRY_WEIGHT=$(echo "$DRY_WEIGHT" | sed 's/"//g')

  
  python3 plant_plots.py \
    --plant "$PLANT" \
    --height $HEIGHT \
    --leaf_count $LEAF_COUNT \
    --dry_weight $DRY_WEIGHT

done


mkdir -p Q4_1
mv *.png Q4_1/ 2>/dev/null


git add Q4_1/*.png 2>/dev/null
git commit -m "Auto-commit from run_plants.sh for Q4"
git push origin master


deactivate

echo "Done! All plots moved to Q4_1 and changes pushed to GitHub."
