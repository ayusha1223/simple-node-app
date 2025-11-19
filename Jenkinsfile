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
                echo "Running OWASP Dependency Check..."
                /opt/dependency-check-cli/bin/dependency-check.sh \
                    --scan . \
                    --format HTML \
                    --out owasp-report
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
