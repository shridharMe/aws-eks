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
            string(defaultValue: "1", description: 'Enter no of workernode required', name: 'NO_OF_WORKER_NODE')
    }
    stages {
        stage ('prerequisite') {
            when {
                expression { params.REFRESH == false }
                expression { params.TERRAFORM_ACTION == "provision" }
            }
            steps {
                dir('prerequisite') {
                  sh '''
                      cp ../provision.sh .
                    chmod +x ./provision.sh                     
                    ./provision.sh -s ${SQUAD_NAME} -e int -r init
                    ./provision.sh -s ${SQUAD_NAME} -e int -r verify
                    ./provision.sh -s ${SQUAD_NAME} -e int -r plan
                    #./provision.sh -s ${SQUAD_NAME} -e int -r apply
                    '''

                }}
        }

        stage('eks') {
            when {
                expression { params.REFRESH == false }
                expression { params.TERRAFORM_ACTION == "provision" }
            }
            
            steps {  
                 dir('eks') {          
                    sh '''
                      cp ../provision.sh .
                    chmod +x ./provision.sh                     
                    ./provision.sh -e int -r init
                    ./provision.sh -e int -r verify
                    ./provision.sh -e int -r plan
                    #./provision.sh -e int -r apply
                    '''
                 }
            } 
        } 
        stage('kubeconfig') {
            when {
                expression { params.REFRESH == false } 
                expression { params.TERRAFORM_ACTION == "provision" }                         
            }
            steps {
                 sh  '''
                        ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r output -m  eks-kube-config                        
                     '''
            }
            
        }
        stage('teardown-prerequisite') {
            when {
                expression { params.REFRESH == false } 
                expression { params.TERRAFORM_ACTION == "teardown" }                         
            }
            steps {
                dir('prerequisite') {
                 sh  '''     
                        cp ../provision.sh .
                        chmod +x ./provision.sh
                        ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy_prereq                                          
                   
                       
                     '''
            }
            }
            
        } 
        stage('teardown-eks') {
            when {
                expression { params.REFRESH == false } 
                expression { params.TERRAFORM_ACTION == "teardown" }                         
            }
            steps {
                dir('eks') {
                 sh  '''     
                        cp ../provision.sh .
                        chmod +x ./provision.sh                      
                        ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r destroy_eks                                        
                   
                       
                     '''
            }
            }
            
        } 
    }
}
