pipeline {
    agent any
    
    environment {
        curImage = '808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project'
    }
    
    stages {
        
        stage('Clone repository') { 
            steps{
                checkout scm
                script{
                    if (env.ENV_OF_RUN == 'production') {
                        echo 'this is testing env'
                        sh "mv ./statuspage/statuspage/configuration-test.py ./statuspage/statuspage/configuration.py"
                        //sh "cat ./statuspage/statuspage/configuration.py"
                    } else {
                        sh "echo 'Hello from production branch!'"
                        sh "mv ./statuspage/statuspage/configuration-production.py ./statuspage/statuspage/configuration.py"
                        //sh "cat ./statuspage/statuspage/configuration.py"
                    }
                }
            }
        }
        
        
        stage('connect to docker') {
            steps{
                
            //Authenticate aws
            withEnv (["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}"]){
                    //login to docker with aws user and the password will be taken from the variable above.
                    sh 'docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 808447716657.dkr.ecr.us-east-1.amazonaws.com'
                }
            }
        }
        
        stage ('docker delete :latest in ECR'){
            steps{
                script{
                    if (env.ENV_OF_RUN == 'production') {
                        sh "aws ecr batch-delete-image --repository-name final_project --image-ids imageTag=testing --region=us-east-1"
                    } else {
                        sh "aws ecr batch-delete-image --repository-name final_project --image-ids imageTag=latest --region=us-east-1"
                    }
                }
            }
        }
        
        stage ('docker build'){
            steps{
                script{
                    if (env.ENV_OF_RUN == 'production') {
                        sh 'docker build -t final_project:testing .'
                    } else {
                        sh 'docker build -t final_project:latest .'
                    }
                    //sh 'docker build -t final_project .'
                }
            }
        }
        
        
        stage ('docker push'){
            steps{
                script{
                    if (env.ENV_OF_RUN == 'production') {
                        sh "docker tag final_project:testing ${curImage}"
                        sh "docker push ${curImage}"
                    } else {
                        sh "docker tag final_project:latest ${curImage}"
                        sh "docker push ${curImage}"
                    }
                }
                    
            }
        }
        
        stage ('docker rm image from local'){
            steps{
                script{
                    if (env.ENV_OF_RUN == 'production') {
                        sh "docker image rm ${curImage}:testing"
                    } else {
                        sh "docker image rm ${curImage}:latest"
                    }
                }
            }
        }
        
       
        
        stage("Connect To ECR") {
            steps{
                sshagent(credentials:['devops']) {
                    sh 'ssh -T -o StrictHostKeyChecking=no ubuntu@54.83.189.131 "docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 808447716657.dkr.ecr.us-east-1.amazonaws.com"'
                }
            }
        }
        
        
        stage("Docker pull image") {
            steps{
                sshagent(credentials:['devops']) {
                    script{
                        if (env.ENV_OF_RUN == 'production') {
                            sh 'ssh -T ubuntu@54.83.189.131 "docker pull 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:testing"'
                        } else {
                            sh 'ssh -T ubuntu@54.83.189.131 "docker pull 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:latest"'
                        }
                    }
                }
            }
        }
        
        
        stage("Docker run") {
            steps{
                sshagent(credentials:['devops']) {
                    script{
                        if (env.ENV_OF_RUN == 'production') {
                            sh 'ssh -T ubuntu@54.83.189.131 "docker run --restart=always -p 8000:8000 --name yarden-ve-aviv -td 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:testing"'
                        } else {
                            sh 'ssh -T ubuntu@54.83.189.131 "docker run --restart=always -p 8000:8000 --name yarden-ve-aviv -td 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:latest"'
                        }
                    }
                }
            }
        }
    }
}
