cd ..
set -u
export BASE=$(pwd)
cd scripts/gem5_scripts/spec06/

for bench in astar omnetpp sphinx3 # xalancbmk soplex mcf not working
do
  #IN=$(grep $bench $BASE/spec_confs/input.txt | awk -F':' '{print $2}'| xargs)
  BIN=$(grep $bench $BASE/spec_confs/binaries.txt | awk -F':' '{print $2}' | xargs)
  BINA=./$(echo $BIN)"_base.amd64-m64-gcc42-nn"
  #echo $BINA
  ARGS=$(grep $bench $BASE/spec_confs/args.txt | awk -F':' '{print $2}'| xargs)
  cd $BASE/scripts/gem5_scripts/spec06/*$bench/
  $BASE/scripts/gem5_scripts/run_ghostminion.sh "$BINA" "$ARGS" $1 > $BASE/scripts/cmd.f
  python3 $BASE/scripts/run_cmds.py --command-file $BASE/scripts/cmd.f --num-workers 12
done


#cd $BASE/scripts/gem5_scripts/gap/bfs/
#$BASE/scripts/gem5_scripts/run_ghostminion.sh "bfs" "-r 1 -f g22.el" $1 > $BASE/scripts/cmd.f
#python3 $BASE/scripts/run_cmds.py --command-file $BASE/scripts/cmd.f --num-workers 12

#cd $BASE/scripts/gem5_scripts/gap/cc/
#$BASE/scripts/gem5_scripts/run_ghostminion.sh "cc" "-r 1 -f g22.el" $1 > $BASE/scripts/cmd.f
#python3 $BASE/scripts/run_cmds.py --command-file $BASE/scripts/cmd.f --num-workers 12


cd $BASE/scripts
