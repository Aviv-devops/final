pipeline {
    agent any
    
    environment {
        curImage = '808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:latest'
        //curImage = '808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:""$BUILD_ID""'
        is-env-test = 'True'
    }
    
    stages {
        
        stage('Clone repository') { 
            steps{
                checkout scm
                sh 'll'
                if (${is-env-test}) {
                    echo 'this is testing env'
                } else {
                    sh "echo 'Hello from production branch!'"
                }
            }
        }
        
        /*
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
                    sh "aws ecr batch-delete-image --repository-name final_project --image-ids imageTag=latest --region=us-east-1"
            }
        }
        
        stage ('docker build'){
            steps{
                    sh 'docker build -t final_project .'
            }
        }
        
        
        stage ('docker push'){
            steps{
                    sh "docker tag final_project:latest ${curImage}"
                    sh "docker push ${curImage}"
            }
        }
        
        stage ('docker rm image from local'){
            steps{
                    sh "docker image rm ${curImage}"
            }
        }
        
       
        
        stage("Connect To ECR") {
            steps{
                sshagent(credentials:['devops']) {
                    //sh 'ssh -t ubuntu@34.229.242.33 "echo heyheyhey"'
                    //sh 'ssh -t -o StrictHostKeyChecking=no ubuntu@34.229.242.33 "echo heyheyhey"'
                    sh 'ssh -T -o StrictHostKeyChecking=no ubuntu@52.55.2.237 "docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 808447716657.dkr.ecr.us-east-1.amazonaws.com"'
                    //sh 'ssh -T ubuntu@34.229.242.33 "docker pull ${curImage}"'
                }
            }
        }
        
        
        stage("Docker pull image") {
            steps{
                sshagent(credentials:['devops']) {
                    //sh 'ssh -T ubuntu@34.229.242.33 "docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 808447716657.dkr.ecr.us-east-1.amazonaws.com"'
                    sh 'ssh -T ubuntu@52.55.2.237 "docker pull 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:latest"'
                    //sh 'ssh -T ubuntu@52.55.2.237 "docker pull 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:$BUILD_ID"'
                }
            }
        }
        
        
        stage("Docker run") {
            steps{
                sshagent(credentials:['devops']) {
                    sh 'ssh -T ubuntu@52.55.2.237 "docker run --restart=always -p 8000:8000 --name yarden-ve-aviv -td 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:latest"'
                    //sh 'ssh -T ubuntu@52.55.2.237 "docker run -p 8000:8000 --name yarden$BUILD_ID -td 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:$BUILD_ID"'
                }
            }
        }
        */
    }
}
