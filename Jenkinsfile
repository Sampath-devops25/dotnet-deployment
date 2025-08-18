pipeline {
    agent any
    environment {
        IMAGE = "yourdockerhub/sampleapp:${BUILD_NUMBER}"
    }
    stages {
        stage('Build') {
            steps {
                sh 'dotnet build src/SampleApp.csproj'
            }
        }
        stage('Test') {
            steps {
                sh 'dotnet test src/SampleApp.csproj'
            }
        }
        stage('Dockerize') {
            steps {
                sh 'docker build -t $IMAGE .'
                sh 'docker push $IMAGE'
            }
        }
        stage('GitOps Update') {
            steps {
                sh '''
                    git clone https://github.com/yourorg/sampleapp-deploy.git
                    cd sampleapp-deploy/k8s/overlays/dev
                    sed -i "s|newTag: .*|newTag: ${BUILD_NUMBER}|g" kustomization.yaml
                    git commit -am "Update image to $BUILD_NUMBER"
                    git push
                '''
            }
        }
    }
}

