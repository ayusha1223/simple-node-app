pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ayusha1223/simple-node-app"
        WSL_IP = "172.31.151.138"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    echo "📦 Installing Node dependencies..."
                    npm install
                '''
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    echo "🔍 Running Trivy scan..."
                    trivy fs . --exit-code 0 --format table
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "🐳 Building Docker image..."
                    docker build -t ${DOCKER_IMAGE}:latest .
                '''
            }
        }

        stage('Docker Login & Push') {
            steps {
                sh '''
                    echo "🔐 Logging into Docker Hub..."
                    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin

                    echo "📤 Pushing image..."
                    docker push ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Deploy to WSL Server') {
            steps {
                sshagent(['local-server-creds']) {
                    sh '''
                        echo "🚀 Deploying to WSL server..."

                        ssh -o StrictHostKeyChecking=no ayusha@${WSL_IP} "
                            docker stop simple-node-app || true &&
                            docker rm simple-node-app || true &&
                            docker pull ${DOCKER_IMAGE}:latest &&
                            docker run -d --name simple-node-app -p 3000:3000 ${DOCKER_IMAGE}:latest
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment complete! Visit: http://${WSL_IP}:3000"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
