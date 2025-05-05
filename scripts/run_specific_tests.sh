set -u
export BASE=/v/filer5b/coursework/2025-spring/cs395t-lin/eturcotte/proj

echo "" > cmd.f

while IFS= read -r line; do
    bench=$(echo "$line" | awk '{print $1}')
    gm=$(echo "$line" | awk '{print $2}')
    l1pf=$(echo "$line" | awk '{print $3}')
    l2pf=$(echo "$line" | awk '{print $4}')

    #IN=$(grep $bench $BASE/spec_confs/input.txt | awk -F':' '{print $2}'| xargs)
    BIN=$(grep $bench $BASE/spec_confs/binaries.txt | awk -F':' '{print $2}' | xargs)
    BINA=./$(echo $BIN)"_base.amd64-m64-gcc42-nn"
    #echo $BINA
    ARGS=$(grep $bench $BASE/spec_confs/args.txt | awk -F':' '{print $2}'| xargs)
    #cd $BASE/scripts/gem5_scripts/spec06/*$bench/
    $BASE/scripts/gem5_scripts/run_ghostminion_specific.sh "$BINA" "$ARGS" "$1" "$gm" "$l1pf" "$l2pf" >> cmd.f
done < $2
python3 $BASE/scripts/run_cmds.py --command-file cmd.f --num-workers 8
