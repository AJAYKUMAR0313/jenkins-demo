pipeline {
    agent any

    parameters {
        choice(name: 'DEPLOY_ENV',   choices: ['staging', 'production'], description: 'Deploy target')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run test suite')
    }

    environment {
        APP_NAME  = 'jenkins-demo'
        VERSION   = "1.0.${BUILD_NUMBER}"
        GIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Building ${APP_NAME} v${VERSION} (${GIT_SHORT})"
                sh 'git log --oneline -3'
            }
        }

        stage('Build') {
            steps {
                sh 'mkdir -p dist reports'
                sh """
                    echo "version=${VERSION}"         > dist/build.properties
                    echo "commit=${GIT_SHORT}"        >> dist/build.properties
                    echo "env=${params.DEPLOY_ENV}"  >> dist/build.properties
                """
                stash name: 'build-output', includes: 'dist/**'
                echo "Build complete — output stashed."
            }
        }

        stage('Test') {
            when { expression { return params.RUN_TESTS } }
            failFast true
            parallel {
                stage('Unit Tests') {
                    steps {
                        unstash 'build-output'
                        sh 'sleep 3' // simulates real test time
                        sh 'echo "PASS unit_login"     > reports/unit.txt'
                        sh 'echo "PASS unit_signup"   >> reports/unit.txt'
                        sh 'echo "PASS unit_api"      >> reports/unit.txt'
                        sh 'cat reports/unit.txt'
                    }
                }
                stage('Lint') {
                    steps {
                        sh 'sleep 2'
                        sh 'echo "No lint errors found." > reports/lint.txt'
                        sh 'cat reports/lint.txt'
                    }
                }
                stage('Security Scan') {
                    steps {
                        unstash 'build-output'
                        sh 'sleep 4'
                        sh 'echo "No critical vulnerabilities found." > reports/scan.txt'
                        sh 'cat reports/scan.txt'
                    }
                }
            }
        }

        stage('Approve') {
            when { expression { return params.DEPLOY_ENV == 'production' } }
            steps {
                script {
                    timeout(time: 24, unit: 'HOURS') {
                        input message: "Deploy ${APP_NAME} v${VERSION} to PRODUCTION?",
                              ok: 'Ship it'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                unstash 'build-output'
                echo "Deploying ${APP_NAME} v${VERSION} to ${params.DEPLOY_ENV}"
                sh 'cat dist/build.properties'
                sh "echo 'DEPLOYED ${VERSION} to ${params.DEPLOY_ENV}' > reports/deploy.log"
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'dist/**, reports/**', allowEmptyArchive: true
            echo "Build ${BUILD_NUMBER} — ${currentBuild.currentResult}"
        }
        success {
            echo "SUCCESS: ${APP_NAME} v${VERSION} deployed to ${params.DEPLOY_ENV}"
        }
        failure {
            echo "FAILURE: check stage logs above"
        }
    }
}
