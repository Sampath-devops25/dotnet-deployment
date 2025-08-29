pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REGISTRY = '809808680744.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = 'dotnet-deployment/dotnet-deployment'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        GIT_CREDENTIALS_ID = 'git-credits'  // Your Git credentials ID in Jenkins
        AWS_CREDENTIALS_ID = 'aws-creds'    // Your AWS credentials ID in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
              git branch: 'main', credentialsId: 'ecr:ap-southeast-1:aws-creds', url: 'https://github.com/Sampath-devops25/dotnet-deployment.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${ECR_REPOSITORY}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${AWS_CREDENTIALS_ID}"
                ]]) {
                    sh """
                        aws --version
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh """
                        docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                        docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Update Kubernetes Deployment Manifest') {
            steps {
                script {
                    // Assumes your k8s deployment yaml is at K8s/base/deployment.yaml
                    sh """
                        sed -i 's|image:.*|image: ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}|g' K8s/base/deployment.yaml

                        git config user.email "jenkins@ci"
                        git config user.name "jenkins"
                        git add K8s/base/deployment.yaml
                        git commit -m "ci: update image tag to ${IMAGE_TAG}"
                        git push origin main
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and deployment manifest update succeeded."
        }
        failure {
            echo "❌ Build or deployment manifest update failed."
        }
    }
}
