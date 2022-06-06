pipeline {
    agent any
    environment {
            REPOSITORY_URI = "tuannm74/api" 

            TAG = "Hello"
            PORT = "5000"
            BUILD_TAG = ""
      }
    stages {
        stage('Build') {
            steps {
                echo 'Building12..'
                   steps {
                script {
                    withCredentials([string(credentialsId: 'DOCKER_USER', variable: 'DOCKER_USER'), string(credentialsId: 'DOCKER_PASSWORD', variable: 'DOCKER_PASSWORD')]) {
						sh "docker login -u $DOCKER_USER -p $DOCKER_PASSWORD"
					}                    
					
                    BUILD_TAG="${GIT_BRANCH.tokenize('/').pop()}-${BUILD_NUMBER}-${GIT_COMMIT.substring(0,7)}"
                    					
					echo "build stage tag: ${TAG}"                    					
                    sh "docker build -f Dockerfile -t ${REPOSITORY_URI}:${TAG}.${BUILD_TAG} --build-arg SERVICE=${TAG} --build-arg PORT=${PORT} ."					
                    sh "docker push ${REPOSITORY_URI}:${TAG}.${BUILD_TAG}"


                    //clean to save disk
					sh "docker image rm ${REPOSITORY_URI}:${TAG}.${BUILD_TAG}"				
				
					//sh "docker image prune -f"
                }  
            }
        }
        stage("deploy") {
            steps {
                echo "deploy stage tag: ${TAG}.${BUILD_TAG}"
				
                sshagent(credentials: ['server-ssh']) {
                    sh "ssh -o StrictHostKeyChecking=no -l ubuntu 54.219.182.125 './deploy_server.sh'" 
					
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
