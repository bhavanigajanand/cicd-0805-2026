pipeline {
    agent any

    environment {
        IMAGE_NAME        = "flask-cicd-app"
        DOCKERHUB_USER    = "bhavanigajanand"
        DOCKERHUB_IMAGE   = "${DOCKERHUB_USER}/${IMAGE_NAME}"
        EC2_USER          = "ec2-user"
        EC2_HOST          = "localhost"  // same EC2, update if deploying remotely
    }

    triggers {
        // Automatically trigger pipeline on GitHub push via webhook
        githubPush()
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Cloning repository...'
                git credentialsId: 'github-credentials',
                    url: 'https://github.com/bhavanigajanand/cicd-0805-2026.git',
                    branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🔨 Building Docker image...'
                sh "docker build -t ${DOCKERHUB_IMAGE}:latest ."
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running basic smoke test...'
                sh """
                    docker run --rm -d --name test-container ${DOCKERHUB_IMAGE}:latest
                    sleep 3
                    CONTAINER_IP=\$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' test-container)
                    curl -f http://\$CONTAINER_IP:5000 || (docker stop test-container && exit 1)
                    docker stop test-container
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '📦 Pushing image to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKERHUB_IMAGE}:latest
                        docker logout
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                echo '🚀 Deploying application...'
                sh '''
                    docker-compose down || true
                    docker-compose up -d --build
                '''
            }
        }

    }

    post {
        success {
            echo '✅ Pipeline completed successfully! App is live on port 5000.'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs above.'
        }
        always {
            echo '🧹 Cleaning up dangling Docker images...'
            sh 'docker image prune -f'
        }
    }
}
