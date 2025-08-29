pipeline {
    agent any

    environment {
        // DOCKER_IMAGE = 'your-dockerhub-username/aspireapp1'
        // DOCKER_TAG = "${env.BUILD_NUMBER}"
        // DEPLOY_DIR = 'k8s/overlays/dev' // Path to your kustomization.yaml
        GIT_CREDENTIALS_ID = 'git-credentials-id' // Replace with your Jenkins Git creds
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/Sampath-devops25/dotnet-deployment.git', credentialsId: "${env.GIT_CREDENTIALS_ID}"
            }
        }

        stage('Restore & Build') {
            steps {
                sh 'dotnet restore AspireApp1.sln'
                sh 'dotnet build AspireApp1.sln --no-restore'
            }
        }

        stage('Test') {
            steps {
                // If you have tests
                // sh 'dotnet test AspireApp1.Tests/AspireApp1.Tests.csproj'
                echo 'Skipping tests (none defined).'
            }
        }

    /*    stage('Publish & Dockerize') {
            steps {
                sh 'dotnet publish AspireApp1.WebAPI/AspireApp1.WebAPI.csproj -c Release -o ./publish'
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
            }
        }

        stage('Update GitOps Deployment') {
            steps {
                script {
                    // Clone the deployment repo if it's separate
                    dir('deployment-repo') {
                        git url: 'https://github.com/Sampath-devops25/dotnet-deployment.git', credentialsId: "${env.GIT_CREDENTIALS_ID}"

                        // Update kustomization.yaml image tag
                        sh """
                        cd ${DEPLOY_DIR}
                        sed -i 's|newTag:.*|newTag: ${DOCKER_TAG}|' kustomization.yaml
                        git config user.name "jenkins"
                        git config user.email "jenkins@ci"
                        git commit -am "CI: Update image tag to ${DOCKER_TAG}"
                        git push
                        """
                    }
                }
            }
        } */
    }

    post {
        success {
            echo '✅ Build and deploy completed successfully!'
        }
        failure {
            echo '❌ Build or deploy failed.'
        }
    }
}
