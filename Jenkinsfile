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

        stage('Run tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('SonarQube Analysis') {
    steps {
        script {
            def scannerHome = tool 'ManualScanner'
            withSonarQubeEnv('MySonarQube') {
                sh "${scannerHome}/bin/sonar-scanner"
            }
        }
    }
}

    }
}
