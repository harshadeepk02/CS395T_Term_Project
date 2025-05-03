
declare -A pfmap
pfmap["noPF"]=Null
pfmap["stridePF"]=StridePrefetcher
pfmap["tagPF"]=TaggedPrefetcher
pfmap["impPF"]=IndirectMemoryPrefetcher
pfmap["ampmPF"]=AMPMPrefetcher
pfmap["slimampmPF"]=SlimAMPMPrefetcher
pfmap["sppPF"]=SignaturePathPrefetcher
pfmap["bopPF"]=BOPPrefetcher
pfmap["sbooePF"]=SBOOEPrefetcher
pfmap["isbPF"]=IrregularStreamBufferPrefetcher
pfmap["stmsPF"]=STeMSPrefetcher

OUTDIR=$(pwd)
	
	$BASE/gem5/build/X86/gem5.opt --outdir $OUTDIR/nogm --stats-file=$OUTDIR/nogm/statsnogm_L1${pf}_L2stridePF.txt --json-config=$OUTDIR/nogm/confignogm_L1${pf}_L2stridePF.json -re -- $BASE/gem5/configs/example/se.py  -c "$1" -o \""$2"\" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=$3 --fast-forward=$3 --mem-size=4096MB
	$BASE/gem5/build/X86/gem5.opt --outdir $OUTDIR/gm --stats-file=$OUTDIR/gm/statsgm_L1${pf}_L2stridePF.txt --json-config=$OUTDIR/gm/configgm_L1${pf}_L2stridePF.json -re -- $BASE/gem5/configs/example/se.py  -c "$1" -o \""$2"\" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=$3 --fast-forward=$3 --mem-size=4096MB --ghostminion --cache_coher --ghost_size="2kB" --iminion --prefetch_ordered

#iterate over L1 tests
for pf in stridePF slimampmPF bopPF
do
	$BASE/gem5/build/X86/gem5.opt --outdir $OUTDIR/nogm --stats-file=$OUTDIR/nogm/statsnogm_L1${pf}_L2stridePF.txt --json-config=$OUTDIR/nogm/confignogm_L1${pf}_L2stridePF.json -re -- $BASE/gem5/configs/example/se.py  -c "$1" -o \""$2"\" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=$3 --fast-forward=$3 --mem-size=4096MB --l1d-hwp-type=${pfmap[$pf]}
	$BASE/gem5/build/X86/gem5.opt --outdir $OUTDIR/gm --stats-file=$OUTDIR/gm/statsgm_L1${pf}_L2stridePF.txt --json-config=$OUTDIR/gm/configgm_L1${pf}_L2stridePF.json -re -- $BASE/gem5/configs/example/se.py  -c "$1" -o \""$2"\" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=$3 --fast-forward=$3 --mem-size=4096MB --ghostminion --cache_coher --ghost_size="2kB" --iminion --prefetch_ordered --l1d-hwp-type=${pfmap[$pf]}
done

#iterate over L2 tests
for pf in tagPF impPF ampmPF sppPF bopPF sbooePF isbPF stmsPF
do
	$BASE/gem5/build/X86/gem5.opt --outdir $OUTDIR/nogm --stats-file=$OUTDIR/nogm/statsnogm_L1noPF_L2${pf}.txt --json-config=$OUTDIR/nogm/confignogm_L1noPF_L2${pf}.json -re $BASE/gem5/configs/example/se.py  -c "$1" -o \""$2"\" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=$3 --fast-forward=$3 --mem-size=4096MB --l2-hwp-type=${pfmap[$pf]}
	$BASE/gem5/build/X86/gem5.opt --outdir $OUTDIR/ecgm --stats-file=$OUTDIR/ecgm/statsecgm_L1noPF_L2${pf}.txt --json-config=$OUTDIR/ecgm/configecgm_L1noPF_L2${pf}.json -re $BASE/gem5/configs/example/se.py  -c "$1" -o \""$2"\" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=$3 --fast-forward=$3 --mem-size=4096MB --ghostminion --cache_coher --ghost_size="2kB" --iminion --prefetch_ordered --l2-hwp-type=${pfmap[$pf]}
done
