cd ..
set -u
export BASE=$(pwd)
cd scripts/gem5_scripts/spec06/

echo > $BASE/scripts/cmd.f

declare -A specmap
specmap["astar"]=473
specmap["omnetpp"]=471
specmap["sphinx3"]=482
specmap["soplex"]=450
specmap["xalancbmk"]=483
specmap["mcf"]=429

P=8
i=0
for bench in xalancbmk astar omnetpp soplex sphinx3 # mcf not working
do
  ((i=i%P)); ((i++==0)) && wait
  (
  #IN=$(grep $bench $BASE/spec_confs/input.txt | awk -F':' '{print $2}'| xargs)
  BIN=$(grep $bench $BASE/spec_confs/binaries.txt | awk -F':' '{print $2}' | xargs)
  BINA=./$(echo $BIN)"_base.amd64-m64-gcc42-nn"
  #echo $BINA
  ARGS=$(grep $bench $BASE/spec_confs/args.txt | awk -F':' '{print $2}'| xargs)
  cd *$bench/
  $BASE/scripts/gem5_scripts/run_ghostminion.sh "$BINA" "$ARGS"
  ) &
done

cd ../gap/
#$BASE/scripts/gem5_scripts/run_ghostminion.sh "bfs" "" "-r 1 -f g22.el" $1 >> $BASE/scripts/cmd.f
#$BASE/scripts/gem5_scripts/run_ghostminion.sh "cc" "" "-r 1 -f g22.el" $1 >> $BASE/scripts/cmd.f
cd $BASE/scripts
