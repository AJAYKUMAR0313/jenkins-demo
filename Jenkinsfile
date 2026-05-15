pipeline {
    agent any
    stage('Tests') {
    failFast true
    parallel {
        stage('Unit Tests') {
            steps {
                sh 'echo "unit: PASS"'
            }
        }
        stage('Lint') {
            steps {
                sh 'echo "lint: PASS"'
            }
        }
        stage('Security Scan') {
            steps {
                // deliberately fail this one
                sh 'exit 1'
            }
        }
    }
}
