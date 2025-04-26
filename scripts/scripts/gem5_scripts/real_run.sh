#!/bin/bash




for dir in ./spec06/* ; do
	nn_file=$(find "$dir" -iname *-nn | head -n 1)	
	inp_file="$dir/inp.in"
	echo "/run_ghostminion.sh $nn_file $inp_file"
	./run_ghostminion.sh $nn_file "$inp_file"
done
