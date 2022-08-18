INPUT=$1
OUTPUT="${INPUT/output/hyp}"
sed 's/\t$//' $INPUT > $OUTPUT
