pipeline {
    agent any

    environment {
        REGISTRY = "docker.io/<your-dockerhub-username>"  // Replace with your Docker Hub username
        IMAGE_NAME = "todo-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Sairam-K5/Jenkins-CI-CD-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    echo "Building Docker image..."
                    docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Login & Push to Docker Hub') {
            steps {
                script {
                    // Make sure you created Jenkins credentials with ID 'dockerhub-creds'
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                        '''
                    }
                }
            }
        }

        stage('Update Kubernetes Deployment') {
            steps {
                script {
                    sh '''
                    echo "Updating deployment.yaml with new image..."
                    sed -i "s|image: .*|image: ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}|g" k8s/deployment.yaml
                    cat k8s/deployment.yaml
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    echo "Applying Kubernetes manifests..."
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl rollout status deployment/todo-app
                    kubectl get pods
                    kubectl get svc
                    '''
                }
            }
        }
    }
}

