#!/usr/bin/env groovy
pipeline {
    agent {
        node { label 'docker' }
    }
      
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '14'))
        timestamps()
    }
    environment {
        AWS_ACCESS_KEY_ID        = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY    = credentials('AWS_SECRET_KEY') 
        TERRAFORM_USER_ARN       = credentials('TERRAFORM_USER_ARN') 
        ENV_NAME                 = "dev"   
        SQUAD_NAME               = "devops"       
    }
    parameters {
        booleanParam(name: 'REFRESH',
            defaultValue: true,
            description: 'Refresh Jenkinsfile and exit.')  
         choice(choices: 'provision\nteardown', description: 'Select option to create or teardown infro', name: 'TERRAFORM_ACTION')                          
        
    }
    stages {
        stage('prerequisite') {
            when {
                expression { params.REFRESH == false }
                expression { params.TERRAFORM_ACTION == "provision" }
            }
            
            steps {            
                    sh ''' 
                        chmod +x ./provision-ci.sh                                                        
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init -m prerequisite
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan -m prerequisite
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply -m prerequisite
                     '''
            }
            
        }
        stage('vpc') {
            when {
                expression { params.REFRESH == false }  
                expression { params.TERRAFORM_ACTION == "provision" }                         
            }
            steps {
                 sh  '''
                                             
                                                   
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init -m vpc
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan -m vpc
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply -m vpc
                     '''
            }
            
        }
        stage('eks-cluster') {
            when {
                expression { params.REFRESH == false }    
                expression { params.TERRAFORM_ACTION == "provision" }                       
            }
            steps {
                 sh  '''
                                             
                                                     
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init -m eks-cluster
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan -m eks-cluster
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply -m eks-cluster
                     '''
            }
            
        } 
        stage('eks-worker-node') {
            when {
                expression { params.REFRESH == false } 
                expression { params.TERRAFORM_ACTION == "provision" }                         
            }
            steps {
                 sh  '''                                            
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init -m eks-worker-node
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan -m eks-worker-node
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply -m eks-worker-node
                     '''
            }
            
        } 
        stage('kubeconfig') {
            when {
                expression { params.REFRESH == false } 
                expression { params.TERRAFORM_ACTION == "provision" }                         
            }
            steps {
                 sh  ''' 
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init -m eks-kube-config
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan -m  eks-kube-config
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply -m  eks-kube-config   

                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r output -m  eks-kube-config
                        
                     '''
            }
            
        }
        stage('teardown-complete') {
            when {
                expression { params.REFRESH == false } 
                expression { params.TERRAFORM_ACTION == "teardown" }                         
            }
            steps {
                 sh  '''     
                        chmod +x ./provision-ci.sh   
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy -m eks-kube-config                                            
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy -m eks-worker-node
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy -m eks-cluster
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy -m vpc
                          
                         aws s3 rm s3://myco-terraform-state --recursive
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy -m prerequisite
                     '''
            }
            
        } 
    }
}
