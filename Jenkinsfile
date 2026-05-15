pipeline {
    agent any

    environment {
        // Static values
        APP_NAME    = 'my-app'
        DEPLOY_ENV  = 'staging'
        VERSION     = "1.0.${BUILD_NUMBER}"   // Groovy interpolation

        // Capture shell output into a variable
        GIT_SHORT   = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()

        // Read from Jenkins credentials store (Phase 4)
        // API_TOKEN = credentials('my-api-token')
    }

    stages {
        stage('Show env') {
            steps {
                echo "App     : ${APP_NAME}"
                echo "Version : ${VERSION}"
                echo "Env     : ${DEPLOY_ENV}"
                echo "Commit  : ${GIT_SHORT}"
                sh 'printenv | sort | grep -E "APP|VERSION|DEPLOY|GIT"'
            }
        }
    }
}
