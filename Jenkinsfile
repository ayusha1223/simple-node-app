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

        stage('OWASP Dependency Check') {
            steps {
                sh '''
                mkdir -p /var/jenkins_home/odc-data

                /opt/dependency-check-v12/bin/dependency-check.sh \
                  --scan . \
                  --format XML \
                  --out dependency-check-report \
                  --data /var/jenkins_home/odc-data \
                  --disableOssIndex \
                  --disableYarnAudit \
                  --failOnCVSS 11
                '''
            }
            post {
                always {
                    dependencyCheckPublisher pattern: 'dependency-check-report/dependency-check-report.xml'
                }
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
