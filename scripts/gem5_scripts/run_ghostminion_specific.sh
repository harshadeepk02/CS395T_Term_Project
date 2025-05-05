
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

GM="$4"
L1PF="$5"
L2PF="$6"

if [[ "$GM" == "gm" || "$GM" == "ecgm" ]]; then
	GHOSTARGS=" --ghostminion --cache_coher --ghost_size="2kB" --iminion --prefetch_ordered"
fi
if [[ "$L1PF" != "noPF" ]]; then
	L1PFARGS=" --l1d-hwp-type=${pfmap[$L1PF]}"
fi
if [[ "$L2PF" != "stridePF" ]]; then
	L2PFARGS=" --l2-hwp-type=${pfmap[$L2PF]}"
fi
	
	echo "$BASE/gem5/build/X86/gem5.opt --outdir $OUTDIR/$GM --stats-file=$OUTDIR/$GM/stats${GM}_L1${L1PF}_L2${L2PF}.txt --json-config=$OUTDIR/$GM/config${GM}_L1${L1PF}_L2${L2PF}.json -re -- $BASE/gem5/configs/example/se.py  -c "$1" -o \""$2"\" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=$3 --fast-forward=$3 --mem-size=4096MB${GHOSTARGS}${L1PFARGS}${L2PFARGS}"
