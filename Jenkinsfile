pipeline {
  agent {
    label 'terraform'
  }

  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  environment {
    TF_DIR = 'terraform/environments/dev'
  }

  stages {

    stage('Checkout Code') {
      steps {
        git url: 'https://github.com/atulyw/cdec-b49.git', branch: 'terraform-v2'
      }
    }

    stage('Terraform Version') {
      steps {
        // Wrapping with credentials so 'aws s3 ls' has access
        withCredentials([usernamePassword(credentialsId: 'aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
          sh 'terraform version'
          sh 'aws --version'
          sh 'aws s3 ls'
        }
      }
    }

    stage('Terraform Init') {
      steps {
        dir("${env.TF_DIR}") {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
            sh 'terraform init -input=false'
          }
        }
      }
    }

    stage('Terraform Format Check') {
      steps {
        dir('terraform') {
          sh 'terraform fmt -check -recursive'
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        dir("${env.TF_DIR}") {
          sh 'terraform validate'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("${env.TF_DIR}") {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
            sh 'terraform plan -input=false -out=tfplan'
          }
        }
      }
    }

    stage('Manual Approval') {
      steps {
        input message: 'Review the Terraform Plan log above. Apply to DEV?', ok: 'Apply'
      }
    }

    stage('Terraform Apply') {
      steps {
        dir("${env.TF_DIR}") {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
            sh 'terraform apply -input=false -auto-approve tfplan'
          }
        }
      }
    }
  }

  post {
    success {
      echo 'SUCCESS: DEV infrastructure deployed from branch terraform-v2.'
      echo 'Next: aws eks update-kubeconfig --region ap-south-1 --name cdec-dev-eks'
    }
    failure {
      echo 'FAILURE: Pipeline failed. Check the failed stage log.'
    }
    always {
      echo 'Build finished. Cleaning workspace...'
      deleteDir()
    }
  }
}
