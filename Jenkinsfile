

pipeline {
  agent {
    label 'terraform'
  }

  options {
    disableConcurrentBuilds() // One DEV deploy at a time — protects Terraform state
    buildDiscarder(logRotator(numToKeepStr: '10')) // Keep last 10 builds
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
     stages {

        stage('Install Terraform & AWS CLI') {
            steps {
                sh '''
                    apt-get update

                    # Install required packages
                    apt-get install -y \
                        unzip \
                        curl \
                        wget \
                        gnupg \
                        software-properties-common

                    #################################################
                    # Install Latest Terraform
                    #################################################

                    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg

                    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
                    https://apt.releases.hashicorp.com \
                    $(lsb_release -cs) main" \
                    | tee /etc/apt/sources.list.d/hashicorp.list

                    apt-get update && apt-get install -y terraform

                    #################################################
                    # Install Latest AWS CLI v2
                    #################################################

                    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

                    unzip awscliv2.zip

                    ./aws/install

                    #################################################
                    # Verify Installation
                    #################################################

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

    // -------------------------------------------------------------------------
    // 3. Terraform Init
    // -------------------------------------------------------------------------
    // Downloads providers and prepares backend (see backend.tf in DEV folder).
    stage('Terraform Init') {
      steps {
        dir("${env.TF_DIR}") {
          sh 'terraform init -input=false'
        }
      }
    }

    // -------------------------------------------------------------------------
    // 4. Terraform Format Check
    // -------------------------------------------------------------------------
    // fmt -check fails the build if .tf files are not formatted.
    // We check from terraform/ (parent of dev) so modules/vpc and modules/eks are included.
    stage('Terraform Format Check') {
      steps {
        dir('terraform') {
          sh 'terraform fmt -check -recursive'
        }
      }
    }

    // -------------------------------------------------------------------------
    // 5. Terraform Validate
    // -------------------------------------------------------------------------
    // Validates configuration syntax and internal references (no AWS changes).
    stage('Terraform Validate') {
      steps {
        dir("${env.TF_DIR}") {
          sh 'terraform validate'
        }
      }
    }

    // -------------------------------------------------------------------------
    // 6. Terraform Plan
    // -------------------------------------------------------------------------
    // Shows what would change in AWS and saves the plan to tfplan.
    // Plan is the "receipt" — apply must use the same file after approval.
    stage('Terraform Plan') {
      steps {
        dir("${env.TF_DIR}") {
          sh 'terraform plan -input=false -out=tfplan'
        }
      }
    }

    // -------------------------------------------------------------------------
    // 7. Manual Approval
    // -------------------------------------------------------------------------
    // Pipeline PAUSES here until a human reviews the plan and clicks "Apply".
    // Prevents accidental infrastructure changes.
    stage('Manual Approval') {
      steps {
        input message: 'Review the Terraform Plan log above. Apply to DEV?', ok: 'Apply'
      }
    }

    // -------------------------------------------------------------------------
    // 8. Terraform Apply
    // -------------------------------------------------------------------------
    // Applies exactly what was saved in tfplan (same changes you approved).
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
      echo 'FAILURE: Pipeline failed. Open the failed stage log (init, fmt, validate, plan, apply).'
    }
    always {
      echo 'Build finished. Cleaning workspace...'
      // deleteDir() works without plugins; use cleanWs() instead if Workspace Cleanup is installed
      deleteDir()
    }
  }
}
