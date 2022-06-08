pipeline {
    agent any
    environment {
            REPOSITORY_URI = "tuannm74/api" 
            TAG = "Hello"
            PORT = "5000"
            BUILD_TAG = ""
	    //DOCKER_USER = credentials('DOCKER_USER')
	    //DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
      }

    stages {
        stage('Build') {
           steps {
            // This step should not normally be used in your script. Consult the inline help for details.
		withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
		    // some block
			sh 'docker build -t tuannm74/api:v10 .'
			sh 'docker push -t tuannm74/api:v10 .'
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
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}

