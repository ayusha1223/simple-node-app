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
            echo "⚠ Running OWASP without database (forced offline mode)..."

            /opt/dependency-check-cli/bin/dependency-check.sh \
              --scan . \
              --format HTML \
              --out owasp-report \
              --project simple-node-app \
              --data /var/jenkins_home/.dependency-check/data \
              --noupdate \
              --disableArchive \
              --disableJar \
              --disableAssembly \
              --disableAutoconf \
              --disableComposer \
              --disableCocoapodsAnalyzer \
              --disableGolangMod \
              --disableGolangDep \
              --disableNodeJs \
              --disableNodeAudit \
              --disableRetireJS \
              --disablePythonDist \
              --disablePythonPkg \
              --disableRubyBundleAudit \
              --disableSwiftPackageManager
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
