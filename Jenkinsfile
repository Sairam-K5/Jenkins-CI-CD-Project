pipeline {
    agent any

    environment {
        REGISTRY = "localhost:5000"
        IMAGE_NAME = "django-app"
        IMAGE_TAG = "latest"
        KUBE_CONFIG = "$HOME/.kube/config"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📦 Cloning GitHub Repository..."
                git branch: 'main', url: 'https://github.com/Sairam-K5/Jenkins-CI-CD-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image to Local Registry') {
            steps {
                echo "📤 Pushing image to local registry..."
                sh "docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "🚀 Deploying to Kubernetes..."
                sh "kubectl apply -f k8s/django-deployment.yaml"
            }
        }

        stage('Sync with ArgoCD') {
            steps {
                echo "🔄 Syncing with ArgoCD..."
                sh '''
                argocd login localhost:8082 --username admin --password admin --insecure || true
                argocd app sync django-cicd || true
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline executed successfully! Application deployed."
        }
        failure {
            echo "❌ Pipeline failed. Please check logs."
        }
    }
}
