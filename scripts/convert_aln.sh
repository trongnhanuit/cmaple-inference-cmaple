#!bin/bash

###### handle arguments ######

ALN_DIR=$1 # aln dir
CMAPLE_PATH=$2 # path to CMAPLE executable
CMAPLE_PARAMS="-overwrite" # CMAPLE params


### pre steps #####



############

for aln_path in "${ALN_DIR}"/*.maple; do
	aln=$(basename "$aln_path")
    echo "Converting alignment ${aln} to PHYLIP format"
    cd ${ALN_DIR} && ${CMAPLE_PATH} -aln ${aln} -out-aln ${aln}.phy -out-format PHYLIP ${CMAPLE_PARAMS}
done