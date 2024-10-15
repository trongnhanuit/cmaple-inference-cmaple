#!bin/bash

###### handle arguments ######

ALN_DIR=$1 # aln dir
OUTPUT_DIR=$2 # output dir
CMAPLE_BASELINE_TREE_PREFIX=$3
CMAPLE_NEW_TREE_PREFIX=$4

### pre steps #####



############

echo "Moving console logs of CMAPLE to ${OUTPUT_DIR}"
mkdir -p ${OUTPUT_DIR}
# remove old results
rm -f ${OUTPUT_DIR}/*.console.log
# copy new results
mv ${ALN_DIR}/*.console.log ${OUTPUT_DIR}

echo "" > ${OUTPUT_DIR}/runtime.log
for aln_path in "${ALN_DIR}"/*.maple; do
	aln=$(basename "$aln_path")
	echo "Runtime of inferring tree from the alignment ${aln} \n" >> ${OUTPUT_DIR}/runtime.log
	echo "- By the CMAPLE baseline: \n" >> ${OUTPUT_DIR}/runtime.log
	grep 'Elapsed (wall clock) time' ${ALN_DIR}/${CMAPLE_BASELINE_TREE_PREFIX}${aln}.console.log >> ${OUTPUT_DIR}/runtime.log
	echo "- By the new CMAPLE: \n" >> ${OUTPUT_DIR}/runtime.log
	grep 'Elapsed (wall clock) time' ${ALN_DIR}/${CMAPLE_NEW_TREE_PREFIX}${aln}.console.log >> ${OUTPUT_DIR}/runtime.log
	echo "---------------------\n\n" >> ${OUTPUT_DIR}/runtime.log
done




echo "Moving IQ-TREE files to ${OUTPUT_DIR}"
# remove old results
rm -f ${OUTPUT_DIR}/*.iqtree
# copy new results
mv ${ALN_DIR}/*.iqtree ${OUTPUT_DIR}

echo "" > ${OUTPUT_DIR}/tree_lhs.log
for aln_path in "${ALN_DIR}"/*.maple; do
	aln=$(basename "$aln_path")
	echo "Likelihoods of trees inferred from the alignment ${aln} \n" >> ${OUTPUT_DIR}/tree_lhs.log
	echo "- By the CMAPLE baseline: \n" >> ${OUTPUT_DIR}/tree_lhs.log
	grep 'Log-likelihood of the tree:' ${ALN_DIR}/${CMAPLE_BASELINE_TREE_PREFIX}${aln}_lh.iqtree >> ${OUTPUT_DIR}/tree_lhs.log
	echo "- By the new CMAPLE: \n" >> ${OUTPUT_DIR}/tree_lhs.log
	grep 'Log-likelihood of the tree:' ${ALN_DIR}/${CMAPLE_NEW_TREE_PREFIX}${aln}_lh.iqtree >> ${OUTPUT_DIR}/tree_lhs.log
	echo "---------------------\n\n" >> ${OUTPUT_DIR}/tree_lhs.log
done

