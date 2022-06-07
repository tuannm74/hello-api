pipeline {

  agent none

  environment {
    DOCKER_IMAGE = "tuannm74/api"
  }

  stages {
    stage("Build") {
      agent {
        node {label 'master'}
      }
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${BUILD_NUMBER}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
        sh "docker image ls | grep ${DOCKER_IMAGE}"
        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
          sh "echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin"
        }
        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
        sh "docker push ${DOCKER_IMAGE}:latest"
        
        // clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
        sh "docker image rm ${DOCKER_IMAGE}:latest"
      }
    }

    stage("Deploy") {
      agent any
      // steps{
      //   withCredentials([sshKey(credentialsId: 'ssh-key', sshKeyVariable: 'SSH_KEY')]) {
      //     sh "ssh -i $SSH_KEY ubuntu@54.255.224.142 './jenkins/api/deploy.sh'"
      //   }
      // }
      steps{
        sshagent(credentials:['ssh-remote']) {
          sh "ssh -o StrictHostKeyChecking=no -l ubuntu 54.255.224.142 '/home/ubuntu/deploy.sh'"
        }
      }
    }
  }

  post {
    success {
      echo "SUCCESSFULY"
    }
    failure {
      echo "FAILED"
    }
  }

}
