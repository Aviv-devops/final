pipeline {
    agent any
    
    environment {
        curImage = '808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:""$BUILD_ID""'
    }
    
    stages {
        
        stage('Clone repository') { 
            steps{
                checkout scm
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
        
        /*
        //from inside the instance
        stage('docker pull'){
            steps{
                sh "docker pull ${curImage}"
            }
        }
        */
        
        stage("Connect To ECR") {
            steps{
                sshagent(credentials:['aws-credentials']) {
                    sh 'ssh -T ubuntu@34.229.242.33 "docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 808447716657.dkr.ecr.us-east-1.amazonaws.com"'
                    //sh 'ssh -T ubuntu@34.229.242.33 "docker pull ${curImage}"'
                }
            }
        }
        
        stage("pull image") {
            steps{
                sshagent(credentials:['aws-credentials']) {
                    //sh 'ssh -T ubuntu@34.229.242.33 "docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 808447716657.dkr.ecr.us-east-1.amazonaws.com"'
                    sh 'ssh -T ubuntu@34.229.242.33 "docker pull ${curImage}"'
                }
            }
        }
        
        
        stage("Docker run") {
            steps{
                sshagent(credentials:['aws-credentials']) {
                    sh 'ssh -T ubuntu@34.229.242.33 "docker run -p 8000:8000 --name yarden1 -it 808447716657.dkr.ecr.us-east-1.amazonaws.com/final_project:latest"'
                }
            }
        }
        //sh 'ssh -T ubuntu@54.83.199.231 "docker pull ${curImage}"'
        
        /*
        stage("Create Container") {
            steps{
            sshagent(credentials:['54.83.199.231']) {
                sh "ssh -t ubuntu@54.83.199.231 'docker run -itd ${curImage}'"
            }}
        }
        */
        
    }
}
