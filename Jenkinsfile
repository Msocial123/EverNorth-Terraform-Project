pipeline {
    agent any

    environment {
        TERRASCAN = '/usr/local/bin/terrascan'
        TFSEC = '/usr/local/bin/tfsec'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'test', url: 'https://github.com/hanzel-sc/EverNorth-Terraform-Project'
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
                archiveArtifacts artifacts: 'reports/*.txt', fingerprint: true
                archiveArtifacts artifacts: 'logfile/*.txt', fingerprint: true

            }
        }
    }
}