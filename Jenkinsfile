pipeline {
    agent any
    
    parameters {
        choice(
            name: 'ACTION', 
            choices: ['apply', 'destroy'], 
            description: 'Choose Terraform action to perform'
        )
        booleanParam(
            name: 'AUTO_APPROVE', 
            defaultValue: false, 
            description: 'Automatically approve Terraform actions (use with caution)'
        )
    }
    
    environment {
        // Update these variables according to your setup
        GITHUB_REPO = 'https://github.com/Indyguy0/TF-projects.git'
        GITHUB_BRANCH = 'feature'
        TERRAFORM_DIR = 'terraform'
        // If you're using AWS credentials
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        // For storing Terraform state in S3 (optional)
        TF_BACKEND_BUCKET = 'babs-sandbox-terraform-state'
        TF_BACKEND_KEY = "sandbox-terraform.tfstate"
        TF_BACKEND_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                // Clean workspace before checking out code
                cleanWs()
                git branch: "${GITHUB_BRANCH}",
                    url: "${GITHUB_REPO}"
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        // Initialize Terraform
                        sh """
                        terraform init \
                            -backend=true \
                            -backend-config="bucket=${TF_BACKEND_BUCKET}" \
                            -backend-config="key=${TF_BACKEND_KEY}" \
                            -backend-config="region=${TF_BACKEND_REGION}"
                        """
                    }
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        // Create Terraform plan
                        sh "terraform plan -out=tfplan"
                    }
                }
            }
        }

        stage('Manual Approval') {
            when {
                allOf {
                    expression { params.ACTION == 'apply' }
                    expression { params.AUTO_APPROVE == false }
                }
            }
            steps {
                // Wait for manual approval before applying changes
                input message: "Apply Terraform changes", ok: 'Confirm'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        // Apply Terraform plan with optional auto-approve
                        def autoApprove = params.AUTO_APPROVE ? '-auto-approve' : ''
                        sh "terraform apply ${autoApprove} tfplan"
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        // Destroy infrastructure with optional auto-approve
                        def autoApprove = params.AUTO_APPROVE ? '-auto-approve' : ''
                        sh "terraform destroy ${autoApprove}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after pipeline completion
            cleanWs()
        }
        success {
            echo "Terraform ${params.ACTION} completed successfully!"
        }
        failure {
            echo "Terraform ${params.ACTION} failed!"
        }
    }
}