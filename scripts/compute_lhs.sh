#!bin/bash

###### handle arguments ######

ALN_DIR=$1 # aln dir
TREE_DIR=$2 # tree dir
IQTREE_PATH=$3 # path to IQ-TREE executable
ML_TREE_PREFIX=$4 # The prefix of ML trees
MODEL=$5 # Substitution model
NUM_THREADS=$6 # the number of threads
IQTREE_PARAMS="-redo" # IQ-TREE params


### pre steps #####



############

for aln_path in "${ALN_DIR}"/*.maple; do
	aln=$(basename "$aln_path")
	echo ""
    cd ${ALN_DIR} && ${IQTREE_PATH} -s ${aln}.phy -m ${MODEL} -te ${TREE_DIR}/${ML_TREE_PREFIX}${aln}.treefile -blfix -pre ${ML_TREE_PREFIX}${aln}_lh ${IQTREE_PARAMS} -nt ${NUM_THREADS}
done