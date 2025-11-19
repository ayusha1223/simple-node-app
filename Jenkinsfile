pipeline {
    agent any

    environment {
        SONAR = credentials('MySonarQube')
        DOCKERHUB_USER = 'ayusha1223'
        DOCKERHUB_PASS = 'ayusha123'
        IMAGE_NAME = 'simple-node-app'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    echo "🔍 Running Trivy FS Scan..."
                    trivy fs . --exit-code 0 --format table
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "🐳 Building Docker image..."
                    docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .
                '''
            }
        }

        stage('Docker Login & Push') {
            steps {
                sh '''
                    echo "🔐 Logging into Docker Hub..."
                    echo $DOCKERHUB_PASS | docker login -u "$DOCKERHUB_USER" --password-stdin
                    
                    echo "📤 Pushing image..."
                    docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy to Local Server (WSL)') {
            steps {
                sh '''
                    echo "🚀 Deploying to local WSL server..."

                    docker rm -f simple-node-app || true

                    docker run -d \
                        --name simple-node-app \
                        -p 3000:3000 \
                        ayusha1223/simple-node-app:latest

                    echo "🎉 Deployment finished!"
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQube') {
                    sh '/opt/sonar-scanner/bin/sonar-scanner'
                }
            }
        }
    }
}
