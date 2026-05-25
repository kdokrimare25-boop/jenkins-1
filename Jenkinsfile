
pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  environment {
    TF_DIR = 'terraform/environments/dev'
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }
    stage('Terraform Version') {
      steps {
        sh 'terraform version'
      }
    }
    stage('Terraform Init') {
      steps {
        dir("${env.TF_DIR}") {
          sh 'terraform init -input=false'
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
          sh 'terraform plan -input=false -out=tfplan'
        }
      }
    }
    stage('Manual Approval') {
      steps {
        input message: 'Review the Terraform Plan above. Deploy to DEV?', ok: 'Apply'
      }
    }
    stage('Terraform Apply') {
      steps {
        dir("${env.TF_DIR}") {
          sh 'terraform apply -input=false -auto-approve tfplan'
        }
      }
    }
  }

  post {
    success {
      echo 'SUCCESS: DEV Terraform stack applied. Run: aws eks update-kubeconfig --region <region> --name <cluster>'
    }
    failure {
      echo 'FAILURE: DEV Terraform deployment failed. Check the stage logs above (init, fmt, validate, plan, apply).'
    }
    always {
      echo 'Pipeline finished. Workspace: terraform/environments/dev'
    }
  }
}
