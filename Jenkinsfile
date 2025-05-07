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