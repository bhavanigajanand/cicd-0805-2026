pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-cicd-app"
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Cloning repository...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🔨 Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running basic smoke test...'
                sh """
                    docker run --rm -d --name test-container -p 5001:5000 ${IMAGE_NAME}:latest
                    sleep 3
                    curl -f http://localhost:5001 || (docker stop test-container && exit 1)
                    docker stop test-container
                """
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
    }
}
