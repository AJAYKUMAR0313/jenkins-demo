pipeline {
    agent any

    parameters {
        choice(
            name: 'DEPLOY_ENV',
            choices: ['staging', 'production'],
            description: 'Target deployment environment'
        )
        booleanParam(
            name: 'RUN_TESTS',
            defaultValue: true,
            description: 'Run the test suite before deploying'
        )
        string(
            name: 'RELEASE_NOTE',
            defaultValue: '',
            description: 'What changed in this release (optional)'
        )
    }

    environment {
        APP_NAME  = 'jenkins-demo'
        VERSION   = "1.0.${BUILD_NUMBER}"
        GIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Building ${APP_NAME} v${VERSION}"
                echo "Deploy target : ${params.DEPLOY_ENV}"
                echo "Run tests     : ${params.RUN_TESTS}"
                echo "Release note  : ${params.RELEASE_NOTE ?: '(none)'}"
            }
        }

        stage('Build') {
            steps {
                sh "mkdir -p dist reports"
                sh """
                    echo "version=${VERSION}"         > dist/build.properties
                    echo "env=${params.DEPLOY_ENV}"  >> dist/build.properties
                    echo "commit=${GIT_SHORT}"        >> dist/build.properties
                """
                sh 'cat dist/build.properties'
            }
        }

        stage('Test') {
            when {
                expression { return params.RUN_TESTS }
            }
            steps {
                echo "Running tests (RUN_TESTS=true)..."
                sh 'echo "PASS all tests" > reports/results.txt'
                sh 'cat reports/results.txt'
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying v${VERSION} to ${params.DEPLOY_ENV}..."
                sh "echo 'Deployed ${APP_NAME} v${VERSION} to ${params.DEPLOY_ENV}' > reports/deploy.log"
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'dist/**, reports/**', allowEmptyArchive: true
            echo "Done: ${APP_NAME} v${VERSION} → ${params.DEPLOY_ENV}"
        }
    }
}
