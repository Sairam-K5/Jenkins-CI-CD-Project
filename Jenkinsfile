pipeline {
    agent {
        kubernetes {
            label 'kaniko-agent'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins/label: kaniko-agent
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - cat
    tty: true
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true
  restartPolicy: Never
  volumes:
  - name: kaniko-secret
    secret:
      secretName: regcred
"""
        }
    }

    environment {
<<<<<<< HEAD
        REGISTRY = "docker.io/sairamk5"
=======
        REGISTRY = "docker.io/sairamk5"         // ✅ Replace with your Docker Hub username
>>>>>>> 64a379c (updated)
        IMAGE_NAME = "todo-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        NAMESPACE = "todo-app"
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Sairam-K5/Jenkins-CI-CD-Project.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                container('kaniko') {
                    script {
                        echo '🚀 Building and pushing Docker image using Kaniko...'
                        sh """
                        /kaniko/executor \
                          --context \$WORKSPACE \
                          --dockerfile \$WORKSPACE/Dockerfile \
                          --destination=\$REGISTRY/\$IMAGE_NAME:\$IMAGE_TAG \
                          --skip-tls-verify
                        """
                    }
                }
            }
        }

        stage('Update Kubernetes Deployment') {
            steps {
                script {
                    echo '📝 Updating deployment.yaml with the new image...'
                    sh """
                    sed -i 's|image: .*|image: \$REGISTRY/\$IMAGE_NAME:\$IMAGE_TAG|' k8s/deployment.yaml
                    cat k8s/deployment.yaml
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    script {
                        echo '🚢 Applying updated Kubernetes manifests...'
                        sh """
                        kubectl create ns \$NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
                        kubectl apply -f k8s/deployment.yaml -n \$NAMESPACE
                        kubectl apply -f k8s/service.yaml -n \$NAMESPACE
                        kubectl rollout status deployment/todo-app -n \$NAMESPACE
                        kubectl get pods -n \$NAMESPACE
                        kubectl get svc -n \$NAMESPACE
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully! Deployment completed.'
        }
        failure {
            echo '❌ Pipeline failed! Check logs for details.'
        }
    }
}

