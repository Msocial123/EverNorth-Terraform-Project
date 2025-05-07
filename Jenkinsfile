pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'Maven 3'
        TERRASCAN = '/usr/local/bin/terrascan'
        TFSEC = '/usr/local/bin/tfsec'
    }
    tools {
        terraform 'Terraform'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'test', url: 'https://github.com/hanzel-sc/EverNorth-Terraform-Project'
            }
        }


        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        // For Linux Deployments (most servers run on Linux)
                        sh "${MAVEN_HOME}/bin/mvn clean verify"
                        sh "${MAVEN_HOME}/bin/mvn clean install"
                    } else {
                        // For Windows-based deployments (usually local testing)
                        bat "${MAVEN_HOME}\\bin\\mvn clean verify"
                        bat "${MAVEN_HOME}\\bin\\mvn clean install"
                    }
                }
            }
        }

        stage('Run Pentest Scan') {
                    steps {
                        sh 'chmod +x scan.sh'
                        sh './scan.sh'
                    }
                }
        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'reports/*.json', fingerprint: true
            }
        }
    }
}