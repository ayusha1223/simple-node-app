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
        echo "Running OWASP (v10) in FULL OFFLINE MODE..."

        /opt/dependency-check-cli/bin/dependency-check.sh \
            --scan . \
            --format HTML \
            --out owasp-report \
            --project simple-node-app \
            --noupdate \
            --disableAssembly \
            --disableAutoconf \
            --disableBundleAudit \
            --disableCocoapodsAnalyzer \
            --disableComposer \
            --disableCPE \
            --disableCPEMatching \
            --disableCPESuppression \
            --disableGolangMod \
            --disableGolangDep \
            --disableMSBuild \
            --disableNodeJS \
            --disableNodePackage \
            --disableNodeAudit \
            --disableNodeJsScan \
            --disableNpmCPE \
            --disableNpmAuditAnalyzer \
            --disableOSSIndex \
            --disableRetireJS \
            --disableRubyBundleAudit \
            --disableSwiftPackageManager \
            --disablePyDist \
            --disablePyPkg \
            --disablePyEnv \
            --disablePip \
            --disablePipfile \
            --disablePoetry
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
