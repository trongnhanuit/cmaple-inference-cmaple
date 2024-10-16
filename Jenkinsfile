//  a JenkinsFile to build iqtree
// paramters
//  1. git branch
// 2. git url


properties([
    parameters([
        booleanParam(defaultValue: false, description: 'Build CMAPLE baseline?', name: 'BUILD_CMAPLE_BASELINE'),
        string(name: 'CMAPLE_BASELINE_BRANCH', defaultValue: 'sprta', description: 'Branch to build the CMAPLE baseline'),
        string(name: 'CMAPLE_BASELINE_COMMIT', defaultValue: 'fce5f2f', description: 'Commit ID of the CMAPLE baseline'),
        
        booleanParam(defaultValue: false, description: 'Build the new CMAPLE?', name: 'BUILD_CMAPLE_NEW'),
        string(name: 'CMAPLE_NEW_BRANCH', defaultValue: 'sprta', description: 'Branch to build the new CMAPLE'),
        string(name: 'CMAPLE_NEW_COMMIT', defaultValue: '', description: 'Commit ID of the new CMAPLE, leave blank for the latest'),
         
        booleanParam(defaultValue: false, description: 'Download testing data?', name: 'DOWNLOAD_DATA'),
        string(name: 'ALN_LOCAL_DIR', defaultValue: '', description: 'The (local, if applicable?) directory containing the testing alignments'),
        
        string(name: 'MODEL', defaultValue: 'UNREST', description: 'Substitution model'),
        booleanParam(defaultValue: false, description: 'Infer ML trees by the CMAPLE baseline?', name: 'INFER_TREE_BY_CMAPLE_BASELINE'),
        booleanParam(defaultValue: true, description: 'Infer ML trees by the new CMAPLE?', name: 'INFER_TREE_BY_CMAPLE_NEW'),
        
        booleanParam(defaultValue: false, description: 'Convert alignments to PHYLIP format?', name: 'CONVERT_ALN_PHYLIP'),
        
        booleanParam(defaultValue: false, description: 'Compute likelihoods of trees inferred by the CMAPLE baseline?', name: 'COMPUTE_LH_CMAPLE_BASELINE'),
        booleanParam(defaultValue: true, description: 'Compute likelihoods of trees inferred by the new CMAPLE?', name: 'COMPUTE_LH_CMAPLE_NEW'),
        string(name: 'NUM_THREADS', defaultValue: '16', description: 'The number of threads to compute tree likelihoods'),
        
        booleanParam(defaultValue: true, description: 'Remove all exiting output files?', name: 'REMOVE_OUTPUT'),
        booleanParam(defaultValue: true, description: 'Use CIBIV cluster?', name: 'USE_CIBIV'),
    ])
])
pipeline {
    agent any
    environment {
        GITHUB_REPO_URL = "https://github.com/iqtree/cmaple.git"
        CMAPLE_BASELINE_NAME = "cmaple_baseline"
        CMAPLE_NEW_NAME = "cmaple_new"
        CMAPLE_BASELINE_TREE_PREFIX = "CMAPLE_BASELINE_tree_"
        CMAPLE_NEW_TREE_PREFIX = "CMAPLE_NEW_tree_"
        LOCAL_OUT_DIR = "/Users/nhan/DATA/tmp/cmaple-inference-cmaple/output"
        
        NCI_ALIAS = "gadi"
        SSH_COMP_NODE = " "
        SSH_COMP_NODE_COMPUTE_LH = " "
        WORKING_DIR = "/scratch/dx61/tl8625/cmaple/ci-cd"
        SCRIPTS_DIR = "${WORKING_DIR}/scripts"
        TOOLS_DIR = "${WORKING_DIR}/tools"
        CMAPLE_BASELINE_DIR = "${WORKING_DIR}/${CMAPLE_BASELINE_NAME}"
        CMAPLE_NEW_DIR = "${WORKING_DIR}/${CMAPLE_NEW_NAME}"
        BUILD_OUTPUT_DIR = "${WORKING_DIR}/builds"
        BUILD_CMAPLE_DIR = "${BUILD_OUTPUT_DIR}/build-new"
        BUILD_BASELINE = "${BUILD_OUTPUT_DIR}/build-baseline"
        CMAPLE_BASELINE_PATH = "${BUILD_BASELINE}/cmaple"
        CMAPLE_NEW_PATH = "${BUILD_CMAPLE_DIR}/cmaple"
        PYTHON_SCRIPT_PATH = "${SCRIPTS_DIR}/extract_visualize_results.py"
        PYPY_PATH="/scratch/dx61/tl8625/tmp/pypy3.10-v7.3.17-linux64/bin/pypy3.10"
        
        DATA_DIR = "${WORKING_DIR}/data"
        ALN_DIR = "${DATA_DIR}/aln"
        TREE_DIR = "${DATA_DIR}/tree"
        OUT_DIR = "${DATA_DIR}/output"
    }
    stages {
        stage('Init variables') {
            steps {
                script {
                    if (params.USE_CIBIV) {
                        NCI_ALIAS = "eingang"
                        SSH_COMP_NODE = " ssh -tt minsky "
                        SSH_COMP_NODE_COMPUTE_LH = " ssh -tt fitch "
                        WORKING_DIR = "/project/AliSim/cmaple"
                        SCRIPTS_DIR = "${WORKING_DIR}/scripts"
                        TOOLS_DIR = "${WORKING_DIR}/tools"
                        CMAPLE_BASELINE_DIR = "${WORKING_DIR}/${CMAPLE_BASELINE_NAME}"
                        CMAPLE_NEW_DIR = "${WORKING_DIR}/${CMAPLE_NEW_NAME}"
                        BUILD_OUTPUT_DIR = "${WORKING_DIR}/builds"
                        BUILD_BASELINE = "${BUILD_OUTPUT_DIR}/build-baseline"
                        BUILD_CMAPLE_DIR = "${BUILD_OUTPUT_DIR}/build-new"
                        CMAPLE_BASELINE_PATH = "${BUILD_BASELINE}/cmaple"
                        CMAPLE_NEW_PATH = "${BUILD_CMAPLE_DIR}/cmaple"
                        PYTHON_SCRIPT_PATH = "${SCRIPTS_DIR}/extract_visualize_results.py"
                        PYPY_PATH="/project/AliSim/tools/pypy3.10-v7.3.17-linux64/bin/pypy3.10"
                        
                        DATA_DIR = "${WORKING_DIR}/data"
                        ALN_DIR = "${DATA_DIR}/aln"
                        TREE_DIR = "${DATA_DIR}/tree"
                        OUT_DIR = "${DATA_DIR}/output"
                        
                        
                    }
                }
            }
        }
        stage('Copy scripts') {
            steps {
                script {
                        sh """
                            ssh -tt ${NCI_ALIAS} << EOF
                        
                            mkdir -p ${WORKING_DIR}
                            mkdir -p ${SCRIPTS_DIR}
                            exit
                            EOF
                        """
                        sh "scp -r scripts/* ${NCI_ALIAS}:${SCRIPTS_DIR}"
                        
                        sh """
                            ssh -tt ${NCI_ALIAS} << EOF
                        
                            mkdir -p ${WORKING_DIR}
                            mkdir -p ${TOOLS_DIR}
                            exit
                            EOF
                        """
                        sh "scp -r tools/* ${NCI_ALIAS}:${TOOLS_DIR}"
                }
            }
        }
        stage('Build the CMAPLE baseline') {
            steps {
                script {
                    if (params.BUILD_CMAPLE_BASELINE) {
                        sh """
                            ssh -tt ${NCI_ALIAS} << EOF
                        
                            mkdir -p ${WORKING_DIR}
                            cd  ${WORKING_DIR}
                            git clone --recursive ${GITHUB_REPO_URL} ${CMAPLE_BASELINE_DIR}
                            cd ${CMAPLE_BASELINE_NAME}
                            git checkout ${params.CMAPLE_BASELINE_BRANCH}
                            git reset --hard ${params.CMAPLE_BASELINE_COMMIT}
                            
                            mkdir -p ${BUILD_OUTPUT_DIR}
                            mkdir -p ${BUILD_BASELINE}
                            cd ${BUILD_BASELINE}
                            rm -rf *
                            exit
                            EOF
                        """
                        
                        sh """
                            ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE}<< EOF
                        
                            chmod +x ${SCRIPTS_DIR}/build_cmaple.sh 
                            sh ${SCRIPTS_DIR}/build_cmaple.sh ${BUILD_BASELINE} ${CMAPLE_BASELINE_DIR} 
                           
                            exit
                            EOF
                        """

                    }
                    else {
                        echo 'Skip building the CMAPLE baseline'
                    }
                }
            }
        }
        stage("Build the new CMAPLE") {
            steps {
                script {
                    if (params.BUILD_CMAPLE_NEW) {
                        git_reset_cmd=""
                        if (params.CMAPLE_NEW_COMMIT != "")
                        {
                            git_reset_cmd="git reset --hard ${params.CMAPLE_NEW_COMMIT}"
                        }
                        
                        sh """
                            ssh -tt ${NCI_ALIAS} << EOF
                        
                            mkdir -p ${WORKING_DIR}
                            cd  ${WORKING_DIR}
                            git clone --recursive ${GITHUB_REPO_URL} ${CMAPLE_NEW_DIR}
                            cd ${CMAPLE_NEW_NAME}
                            git checkout ${params.CMAPLE_NEW_BRANCH}
                            ${git_reset_cmd}
                        
                            mkdir -p ${BUILD_OUTPUT_DIR}
                            mkdir -p ${BUILD_CMAPLE_DIR}
                            cd ${BUILD_CMAPLE_DIR}
                            rm -rf *
                            exit
                            EOF
                        """
                        
                        sh """
                            ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE}<< EOF
                        
                            chmod +x ${SCRIPTS_DIR}/build_cmaple.sh 
                            sh ${SCRIPTS_DIR}/build_cmaple.sh ${BUILD_CMAPLE_DIR} ${CMAPLE_NEW_DIR} 
                           
                            exit
                            EOF
                        """

                    }
                    else {
                        echo 'Skip building the new CMAPLE'
                    }
                }
            }
        }
        stage('Download testing data') {
            steps {
                script {
                    if (params.DOWNLOAD_DATA) {
                        sh """
                            ssh -tt ${NCI_ALIAS} << EOF

                            mkdir -p ${WORKING_DIR}
                            cd  ${WORKING_DIR}
                            mkdir -p ${ALN_DIR}
                            exit
                            EOF
                        """
                        sh "rsync -avz --include=\"*/*\" ${params.ALN_LOCAL_DIR}/*.* ${NCI_ALIAS}:${ALN_DIR}"
                    }
                    else {
                        echo 'Skip downloading testing data'
                    }
                }
            }
        }
        stage('Infer trees by the CMAPLE baseline') {
            steps {
                script {
                    if (params.INFER_TREE_BY_CMAPLE_BASELINE) {
                        sh """
                            ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE}<< EOF
                    
                            sh ${SCRIPTS_DIR}/infer_tree.sh ${ALN_DIR} ${TREE_DIR} ${CMAPLE_BASELINE_PATH} ${CMAPLE_BASELINE_TREE_PREFIX} ${params.MODEL}
                        
                            exit
                            EOF
                        """
                    }
                    else {
                        echo 'Skip inferring trees by the CMAPLE baseline'
                    }
                }
            }
        }
        stage('Convert alignments to PHYLIP format') {
            steps {
                script {
                    if (params.CONVERT_ALN_PHYLIP) {
                        sh """
                            ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE}<< EOF
                    
                            sh ${SCRIPTS_DIR}/convert_aln.sh ${ALN_DIR} ${CMAPLE_BASELINE_PATH}
                        
                            exit
                            EOF
                        """
                    }
                    else {
                        echo 'Skip converting alignments to PHYLIP format'
                    }
                }
            }
        }
        stage('Compute the likelihoods of the trees inferred by the CMAPLE baseline') {
            steps {
                script {
                    if (params.COMPUTE_LH_CMAPLE_BASELINE) {
                        sh """
                            ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE_COMPUTE_LH}<< EOF
                    
                            sh ${SCRIPTS_DIR}/compute_lhs.sh ${ALN_DIR} ${TREE_DIR} ${TOOLS_DIR}/iqtree2 ${CMAPLE_BASELINE_TREE_PREFIX} ${params.MODEL} ${params.NUM_THREADS}
                        
                            exit
                            EOF
                        """
                    }
                    else {
                        echo 'Skip computing the likelihoods of the trees inferred by the CMAPLE baseline'
                    }
                }
            }
        }
        stage('Infer trees by the new CMAPLE') {
            steps {
                script {
                    if (params.INFER_TREE_BY_CMAPLE_NEW) {
                        sh """
                            ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE}<< EOF
                    
                            sh ${SCRIPTS_DIR}/infer_tree.sh ${ALN_DIR} ${TREE_DIR} ${CMAPLE_NEW_PATH} ${CMAPLE_NEW_TREE_PREFIX} ${params.MODEL}
                        
                            exit
                            EOF
                        """
                    }
                    else {
                        echo 'Skip inferring trees by the new CMAPLE'
                    }
                }
            }
        }
        stage('Compute the likelihoods of the trees inferred by the new CMAPLE') {
            steps {
                script {
                    if (params.COMPUTE_LH_CMAPLE_BASELINE) {
                        sh """
                            ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE_COMPUTE_LH}<< EOF
                    
                            sh ${SCRIPTS_DIR}/compute_lhs.sh ${ALN_DIR} ${TREE_DIR} ${TOOLS_DIR}/iqtree2 ${CMAPLE_NEW_TREE_PREFIX} ${params.MODEL} ${params.NUM_THREADS}
                        
                            exit
                            EOF
                        """
                    }
                    else {
                        echo 'Skip computing the likelihoods of the trees inferred by the new CMAPLE'
                    }
                }
            }
        }
        stage('Extract the results (runtime and tree likelihoods)') {
            steps {
                script {
                    if (params.REMOVE_OUTPUT) {
                        sh """
                            ssh -tt ${NCI_ALIAS} << EOF
                            rm -f ${OUT_DIR}/*
                            exit
                            EOF
                        """
                        sh "rm -f {LOCAL_OUT_DIR}/*"
                    }
                    sh """
                        ssh -tt ${NCI_ALIAS} ${SSH_COMP_NODE}<< EOF
                                              
                        sh ${SCRIPTS_DIR}/extract_results.sh ${ALN_DIR} ${OUT_DIR} ${CMAPLE_BASELINE_TREE_PREFIX} ${CMAPLE_NEW_TREE_PREFIX} 
                        
                        exit
                        EOF
                        """
                    sh "mkdir -p {LOCAL_OUT_DIR} && rsync -avz --include=\"*/*\" ${NCI_ALIAS}:${OUT_DIR}/ ${LOCAL_OUT_DIR}"
                    sh "mkdir -p {LOCAL_OUT_DIR} && rsync -avz --include=\"*/*\" ${NCI_ALIAS}:${TREE_DIR} ${LOCAL_OUT_DIR}"
                }
            }
        }
        stage ('Verify') {
            steps {
                script {
                    sh """
                        ssh -tt ${NCI_ALIAS} << EOF
                        cd  ${WORKING_DIR}
                        echo "Files in ${WORKING_DIR}"
                        ls -ila ${WORKING_DIR}
                        echo "Files in ${ALN_DIR}"
                        ls -ila ${ALN_DIR}
                        echo "Files in ${TREE_DIR}"
                        ls -ila ${TREE_DIR}
                        exit
                        EOF
                        """
                }
            }
        }


    }
    post {
        always {
            echo 'Cleaning up workspace'
            cleanWs()
        }
    }
}

def void cleanWs() {
    // ssh to NCI_ALIAS and remove the working directory
    // sh "ssh -tt ${NCI_ALIAS} 'rm -rf ${REPO_DIR} ${BUILD_SCRIPTS}'"
}