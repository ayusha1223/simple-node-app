pipeline {
    agent any

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

        stage('OWASP Dependency Check') {
            steps {
                sh '''
                    echo "Running OWASP in FULL OFFLINE MODE..."
                    /opt/dependency-check-cli/bin/dependency-check.sh \
                      --scan . \
                      --format HTML \
                      --out owasp-report \
                      --project simple-node-app \
                      --noupdate
                '''
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    echo "Running Trivy FileSystem Scan..."
                    trivy fs . --exit-code 0 --format html --output trivy-report.html
                '''
            }
        }

        stage('Build Node App') {
            steps {
                sh '''
                    echo "Building application..."
                    npm run build || true
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQube') {
                    sh '''
                        /opt/sonar-scanner/bin/sonar-scanner
                    '''
                }
            }
        }
    }
}
