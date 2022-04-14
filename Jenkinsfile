pipeline {
  agent any
  environment {
    CONTAINER_TAG = "eshop_test"
    CONTAINER_NAME = "${env.JOB_NAME}_${env.BUILD_NUMBER}"
    DOCKERHUB_CREDENTIALS=credentials('48caa4ed-1758-4fc4-8260-17418ce9cde9')
  }
  stages {
    stage('Containers'){
      steps {
        sh "mkdir -p volume"
        sh "docker build -t ${CONTAINER_TAG} ."
        sh "docker run -d --name ${CONTAINER_NAME} -v /usr/work:${env.WORKSPACE}/volume ${CONTAINER_TAG} watch 'date >> /var/log/date.log'"
      }
    }
    stage('Restore'){
      parallel{
        stage('Web'){
          steps{
            sh "docker exec ${CONTAINER_NAME} dotnet restore ./src/Web/"
          }
        }
        stage('Api'){
          steps{
            sh "docker exec ${CONTAINER_NAME} dotnet restore ./src/PublicApi/"
          }
        }
      }
    }
    stage('UnitTests'){
      steps {
        sh "docker exec ${CONTAINER_NAME} dotnet test ./tests/UnitTests/UnitTests.csproj"
      }
    }
    stage('IntegrationTests'){
      parallel{
        stage('Web'){
          steps{
            sh "docker exec ${CONTAINER_NAME} dotnet test ./tests/IntegrationTests/IntegrationTests.csproj"
          }
        }
        stage('Api'){
          steps{
            sh "docker exec ${CONTAINER_NAME} dotnet test ./tests/PublicApiIntegrationTests/PublicApiIntegrationTests.csproj"
          }
        }
      }
    }
    stage('FunctionalTests'){
      steps{
        sh "docker exec ${CONTAINER_NAME} dotnet test ./tests/FunctionalTests/FunctionalTests.csproj"
      }
    }
    stage('Publish'){
      parallel{
        stage('Web'){
          steps{
           sh "docker exec ${CONTAINER_NAME} dotnet publish ./src/Web/Web.csproj -o ./src/Web/bin/Publish/Web/ -v d -r linux-x64"
          }
        }
        stage('Api'){
          steps{
            sh "docker exec ${CONTAINER_NAME} dotnet publish ./src/PublicApi/PublicApi.csproj -o ./src/PublicApi/bin/Publish/PublicApi/ -v d -r linux-x64"
          }
        }
      }
    }
    stage('Login'){
      steps{
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push Image'){
      parallel{
        stage('Web'){
          steps{
            sh "docker build . -t ravenfill/eshop_web:${env.BUILD_NUMBER} -f volume/src/Web/Dockerfile"
            sh "docker push ravenfill/eshop_web:${env.BUILD_NUMBER}"
          }
        }
        stage('Api'){
          steps{
            sh "docker build . -t ravenfill/eshop_api:${env.BUILD_NUMBER} -f volume/src/PublicApi/Dockerfile"
            sh "docker push ravenfill/eshop_api:${env.BUILD_NUMBER}"
          }
        }
      }
    }
  }
  post {
    always {
      sh 'docker logout'
      sh 'docker stop ${CONTAINER_NAME}'
      sh 'docker rm ${CONTAINER_NAME}'
      sh 'docker rmi ${CONTAINER_TAG}'
      sh 'rm -rf volume'
    }
  }
}