// =============================================================================
// Jenkins Declarative Pipeline — Terraform DEV (AWS VPC + EKS)
// =============================================================================
//
// Repository : https://github.com/atulyw/cdec-b49.git
// Branch     : terraform-v2
// Terraform  : terraform/environments/dev
//
// Suggested Jenkins job name: terraform-eks-dev-deploy
//
// Agent label: terraform (must have terraform + aws CLI, or use Install stage below)
//
// Optional plugins (add to options {} after install):
//   Timestamper → timestamps()
//   AnsiColor   → ansiColor('xterm')
// =============================================================================

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

    // Skip this stage if your agent already has terraform and aws CLI installed.
    stage('Install Terraform & AWS CLI') {
      steps {
        sh '''
          set -e
          apt-get update
          apt-get install -y unzip curl wget gnupg software-properties-common

          wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg
          echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
          apt-get update && apt-get install -y terraform

          curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
          unzip -q awscliv2.zip
          ./aws/install

          terraform version
          aws --version
        '''
      }
    }

    stage('Terraform Version') {
      steps {
        sh 'terraform version'
        sh 'aws --version'
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
        input message: 'Review the Terraform Plan log above. Apply to DEV?', ok: 'Apply'
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
