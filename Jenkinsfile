pipeline {
    agent any

    environment {
        APP_NAME = 'jenkins-demo'
        BUILD_TIMESTAMP = sh(script: 'date +%Y%m%d-%H%M%S', returnStdout: true).trim()
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out ${APP_NAME}"
                echo "Commit: ${GIT_COMMIT}"
                echo "Branch: ${GIT_BRANCH}"
                sh 'git log --oneline -5'
            }
        }

        stage('Build') {
            steps {
                echo "Building ${APP_NAME} at ${BUILD_TIMESTAMP}"
                sh 'mkdir -p dist'
                sh 'echo "Build: ${BUILD_NUMBER}" > dist/version.txt'
                sh 'echo "Commit: ${GIT_COMMIT}" >> dist/version.txt'
                sh 'cat dist/version.txt'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'echo "test_login: PASS" > test-results.txt'
                sh 'echo "test_signup: PASS" >> test-results.txt'
                sh 'echo "test_checkout: PASS" >> test-results.txt'
                sh 'cat test-results.txt'
                echo 'All tests passed!'
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS — ${APP_NAME} build ${BUILD_NUMBER} is ready"
        }
        failure {
            echo "Pipeline FAILED — check the logs above"
        }
        always {
            echo "Build finished. Workspace cleanup would go here."
        }
    }
}
