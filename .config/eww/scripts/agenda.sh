DATEFORMAT='%a. %d %b, %I:%M %p' ## day_name day_num mon 12hr clock
GCAL="$HOME/.cache/eww/rightbar_gcal"
AGENDA="$HOME/.cache/eww/rightbar_agenda"

if [[ ! -f "$GCAL" ]] || [[ ! -f "$AGENDA" ]]; then
    mkdir -p "$HOME/.cache/eww"
    touch "$GCAL"; touch "$AGENDA"
fi

if [[ -s "$AGENDA" ]]; then
    > "$AGENDA"
fi

gcalcli --refresh --nocolor agenda --nostarted --tsv --details=calendar > "$GCAL"

while read line; do
    d=$(awk -F'\t' '{print $1,$2}' <<< $line)
    d=$(date -d "$d" "+$DATEFORMAT")
    e=$(awk -F'\t' '{print $5}' <<< $line)
    c=$(awk -F'\t' '{print $6}' <<< $line)
    printf '%s - %s (%s)\n' "$d" "$e" "$c" >> "$AGENDA"
done  < $GCAL

cat "$AGENDA"
