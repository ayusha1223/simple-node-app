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
