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
            choice(choices: 'prerequiste\neks-all\neks-cluster\neks-worker-node\nvpc', description: 'Select aws resource\n Note: "eks-all" will create all resources at once', name: 'AWS_RESOURCE')                             
            string(defaultValue: "1", description: 'Enter no of workernode required', name: 'NO_OF_WORKER_NODE')
    }
    stages {
        stage('init') {
            when {
                expression { params.REFRESH == false }
                expression { params.TERRAFORM_ACTION == "provision" }
            }
            
            steps {            
                    sh ''' 
                        chmod +x ./provision-ci.sh                                                        
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init -m $AWS_RESOURCE
                     '''
            } 
        }
         stage('verify') {
            when {
                expression { params.REFRESH == false }
                expression { params.TERRAFORM_ACTION == "provision" }
            }
            steps {            
                    sh ''' 
                                                                               
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r verify -m $AWS_RESOURCE                        

                     '''
            }    
         }  
        stage('plan') {
            when {
                expression { params.REFRESH == false }
                expression { params.TERRAFORM_ACTION == "provision" }
            }
            steps {            
                    sh ''' 
                                                                            
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan -m $AWS_RESOURCE                        

                     '''
            }    
         }   
       stage('apply') {
            when {
                expression { params.REFRESH == false }
                expression { params.TERRAFORM_ACTION == "provision" }
            }
            
            steps {            
                    sh ''' 
                                                                              
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply -m $AWS_RESOURCE
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
                        if [ "$AWS_RESOURCE" == "prerequisite" ]; then
                         aws s3 rm s3://myco-terraform-state --recursive 
                        fi
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy -m  $AWS_RESOURCE                                            
                   
                       
                     '''
            }
            
        } 
    }
}
