pipeline {
    agent any

    tools {
        nodejs "node18"      // Must match NodeJS name in Manage Jenkins -> Tools
    }

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

        stage('Run tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('local-sonar') {   // Must match SonarQube server name in Jenkins
                    sh 'sonar-scanner'
                }
            }
        }
    }
}
