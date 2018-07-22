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
        ENV_NAME                 = "dev"   
        SQUAD_NAME               = "devops"       
    }
    parameters {
        booleanParam(name: 'REFRESH',
            defaultValue: true,
            description: 'Refresh Jenkinsfile and exit.')       
        
    }
    stages {
        stage('prerequisite') {
            when {
                expression { params.REFRESH == false }
            }
            
            steps {            
                    sh ''' 
                        chmod +x ./provision-ci.sh  
                                                      
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply
                     '''
            }
            
        }
        stage('vpc') {
            when {
                expression { params.REFRESH == false }                           
            }
            steps {
                 sh  '''
                                             
                      chmod +x ./provision-ci.sh   
                        cd vpc/                               
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply
                     '''
            }
            
        }
        stage('eks-cluster') {
            when {
                expression { params.REFRESH == false }                           
            }
            steps {
                 sh  '''
                                             
                                                     
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply
                     '''
            }
            
        } 
        stage('eks-worker-node') {
            when {
                expression { params.REFRESH == false }                           
            }
            steps {
                 sh  '''                                            
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan
                        ./provision-ci.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply
                     '''
            }
            
        } 
    }
}
