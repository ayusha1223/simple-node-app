pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ayusha1223/simple-node-app"
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

        stage('SonarQube Scan') {
    steps {
        withSonarQubeEnv('sonarqube') {
            sh '''
                echo "🔎 Running SonarQube analysis..."
                /opt/sonar-scanner/bin/sonar-scanner \
                -Dsonar.projectKey=simple-node-app \
                -Dsonar.sources=. \
                -Dsonar.host.url=http://localhost:9000 \
                -Dsonar.login=$SONAR_AUTH_TOKEN
            '''
        }
    }
}

stage('OWASP Dependency Check') {
    steps {
        sh '''
            echo "🔐 Running OWASP Dependency-Check..."
            /opt/dependency-check/bin/dependency-check.sh \
            --scan . \
            --format HTML \
            --out dependency-check-report \
            --disableAssembly
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
            environment {
                DOCKER_BUILDKIT = "0"
            }
            steps {
                sh '''
                    echo "🐳 Building Docker image..."
                    docker build -t ${DOCKER_IMAGE}:latest .
                '''
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )
                ]) {
                    sh '''
                        echo "🔐 Logging into Docker Hub..."
                        echo "$PASS" | docker login -u "$USER" --password-stdin

                        echo "📤 Pushing image..."
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }

        /*
        ==============================
        DEPLOY STAGE (COMMENTED)
        ==============================
        stage('Deploy') {
            steps {
                echo "Deployment will be added later"
            }
        }
        */
    }

    post {
    always {
        echo "📦 Archiving OWASP Dependency-Check report..."
        archiveArtifacts artifacts: 'dependency-check-report/**', fingerprint: true
    }
    success {
        echo "🎉 CI Pipeline completed successfully with SonarQube!"
    }
    failure {
        echo "❌ Pipeline failed!"
    }
}

