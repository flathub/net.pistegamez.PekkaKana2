#!/usr/bin/env sh

DATA_OLD="$(dirname "$XDG_DATA_HOME")/.pekka-kana-2"
echo $DATA_OLD

DATA_NEW=$XDG_DATA_HOME

# migrate saves.dat
if [ ! -f "$DATA_NEW/saves.dat" ] && [ -f "$DATA_OLD/saves.dat" ]; then
    mkdir -p "$DATA_NEW"
    cp -a "$DATA_OLD/saves.dat" "$DATA_NEW/"
fi

# migrate scores
SCORES_NEW="$DATA_NEW/scores"
if [ ! -d "$SCORES_NEW" ] && [ -d "$DATA_OLD" ]; then
    mkdir -p "$SCORES_NEW"

    for dir in "$DATA_OLD"/*; do
        [ -d "$dir" ] || continue

        OLD_FILE="$dir/scores.dat"
        [ -f "$OLD_FILE" ] || continue

        BASENAME="$(basename "$dir")"

        # change "-" to spaces

        NAME="$(echo "$BASENAME" | tr '-' ' ')"
        NEW_FILE="$SCORES_NEW/$NAME.dat"

        if [ ! -f "$NEW_FILE" ]; then
            cp -a "$OLD_FILE" "$NEW_FILE"
        fi
    done
fi



exec /app/share/games/pekka-kana-2/pekka-kana-2 \
    --assets-path /app/share/games/pekka-kana-2 \
    --data-path "$DATA_NEW"