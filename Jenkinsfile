pipeline {
    agent any
    environment {
            REPOSITORY_URI = "tuannm74/api" 
            TAG = "Hello"
            PORT = "5000"
            BUILD_TAG = ""
	    DOCKER_USER = credentials('DOCKER_USER')
	    DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
	    SERVER_NAME = credentials('SERVER_NAME')
	    SERVER_IP = credentials('SERVER_IP')
      }

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                script {
		    sh " docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}"		
                    BUILD_TAG="${GIT_BRANCH.tokenize('/').pop()}-${BUILD_NUMBER}-${GIT_COMMIT.substring(0,7)}"
                    					
		    echo "build stage tag: ${TAG}"  
	            
		    sh "docker build -t ${REPOSITORY_URI}:${TAG}.${BUILD_TAG} ."
		    
                    //sh "docker build -f Dockerfile -t ${REPOSITORY_URI}:${TAG}.${BUILD_TAG} --build-arg SERVICE=${TAG} --build-arg PORT=${PORT} ."					
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
                    sh "ssh -o StrictHostKeyChecking=no -l ${SERVER_NAME} ${SERVER_IP} './deploy_server.sh ${REPOSITORY_URI} ${TAG} ${BUILD_TAG}'" 
					
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
  
    }
}

