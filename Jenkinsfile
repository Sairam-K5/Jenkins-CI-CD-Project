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
  restartPolicy: Never
  volumes:
  - name: kaniko-secret
    secret:
      secretName: regcred
"""
        }
    }

    environment {
        REGISTRY = "docker.io/sairamk5"
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

        stage('Build & Push Docker Image') {
            steps {
                container('kaniko') {
                    script {
                        echo 'Building Docker image with Kaniko and pushing...'
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
                    sh """
                    echo "Updating deployment.yaml with new image..."
                    sed -i "s|image: .*|image: \$REGISTRY/\$IMAGE_NAME:\$IMAGE_TAG|g" k8s/deployment.yaml
                    cat k8s/deployment.yaml
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    echo "Applying Kubernetes manifests..."
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl rollout status deployment/todo-app -n todo-app
                    kubectl get pods -n todo-app
                    kubectl get svc -n todo-app
                    """
                }
            }
        }
    }
}


