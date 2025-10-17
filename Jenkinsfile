pipeline {
    agent any

    environment {
        REGISTRY = "localhost:5000"
        IMAGE_NAME = "django-app"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Sairam-K5/Jenkins-CI-CD-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $REGISTRY/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Local Registry') {
            steps {
                sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
