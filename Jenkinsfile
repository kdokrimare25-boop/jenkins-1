// =============================================================================
// Jenkins Declarative Pipeline — Terraform DEV (AWS VPC + EKS)
// =============================================================================
//
// Repository : git@github.com:atulyw/cdec-b49.git
// Branch     : terraform-v2
// Terraform  : terraform/environments/dev
//
// Suggested Jenkins job name: terraform-eks-dev-deploy
//
// Prerequisites on the Jenkins agent:
//   - terraform, aws CLI installed
//   - AWS credentials (instance role or environment)
//   - GitHub SSH access (credential ID below must exist on Jenkins)
//
// No Jenkins parameters — keeps this pipeline easy to learn and maintain.
// =============================================================================

pipeline {
  agent {
    agent 'terraform'
  }

  options {
    timestamps()              // Log lines include time — useful for long applies
    ansiColor('xterm')        // Colored console (AnsiColor plugin)
    disableConcurrentBuilds() // One DEV deploy at a time — protects Terraform state
  }

  environment {
    // --- Git (explicit checkout — not relying on job SCM UI alone) ---
    GIT_URL            = 'git@github.com:atulyw/cdec-b49.git'
    GIT_BRANCH         = 'terraform-v2'
    // Create this credential in Jenkins: SSH Username with private key for GitHub
    GIT_CREDENTIALS_ID = 'git'
    GIT_SSH_COMMAND = "ssh -o StrictHostKeyChecking=no"

    // --- Terraform working directory (DEV stack only) ---
    TF_DIR = 'terraform/environments/dev'
  }

  stages {

    // -------------------------------------------------------------------------
    // 1. Checkout Code
    // -------------------------------------------------------------------------
    // Jenkins clones your GitHub repo over SSH so the agent has Terraform code.
    // SSH is required because the remote URL is git@github.com:... (not HTTPS).
    stage('Checkout Code') {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: "*/${env.GIT_BRANCH}"]],
          extensions: [
            [$class: 'CloneOption', depth: 1, shallow: true, noTags: true]
          ],
          userRemoteConfigs: [[
            url: "${env.GIT_URL}",
            credentialsId: "${env.GIT_CREDENTIALS_ID}"
          ]]
        ])
      }
    }

    // -------------------------------------------------------------------------
    // 2. Terraform Version
    // -------------------------------------------------------------------------
    // Quick sanity check: Terraform is installed and on PATH.
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
      // Requires "Workspace Cleanup" plugin — removes checkout to save disk space
      cleanWs(
        cleanWhenNotBuilt: false,
        deleteDirs: true,
        disableDeferredWipeout: true,
        notFailBuild: true
      )
    }
  }
}
