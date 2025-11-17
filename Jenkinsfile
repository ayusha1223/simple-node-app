pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('MySonarQube') {
            sh 'echo "SONAR HOST: $SONAR_HOST_URL"'
            sh 'echo "TOKEN: $SONAR_AUTH_TOKEN"'
            sh "/opt/sonar-scanner/sonar-scanner-7.3.0.5189/bin/sonar-scanner"
        }
    }
}

        stage('Run tests') {
            steps {
                sh 'npm test'
            }
        }
    }
}
