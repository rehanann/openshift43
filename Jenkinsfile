pipeline {
  agent any
  environment {
    SVC_ACCOUNT_KEY = credentials('terraform-auth')
    INVENTORY = credentials('INVENTORY_INI')
    TERRAFORMTFVARS = credentials('TERRAFORMTFVARS')
  }
  stages {
            stage('Checkout') {
                steps {
                    checkout scm
                    sh 'echo $SVC_ACCOUNT_KEY | base64 -d > serviceaccount.json'
                    sh 'echo $INVENTORY  | base64 -d > inventory.ini'
                    sh 'echo $TERRAFORMTFVARS | base64 -d > terraform/terraform.tfvars'
                    }
             }
            stage('TF Plan') {
                steps {
                sh 'cd terraform; terraform init'
                sh './plan.sh terraform'
            }
        }
        // stage('Approval') {
        //         steps {
        //             script {
        //              def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
        //         }
        //     }
        // }
        stage('TF Apply') {
                steps {
                    sh './apply.sh terraform'
                    sh 'cp myplan ../gcp-destroy/'
                    sh 'cp terraform.tfstate* ../gcp-destroy/'
                    sh 'sleep 60'
            }
        }
    //     stage('Pre-req Installation') {
    //             steps {
    //                 sh 'export ANSIBLE_HOST_KEY_CHECKING=False'
    //                 sh 'ansible-playbook -i inventory.ini ansible-pb/config.yml'
    //                 sh 'sleep 120'
    //             }
    //     }
    //     stage('Docker storage') {
    //         steps {
    //                 sh 'ansible-playbook -i inventory.ini ansible-pb/docker-storage-setup-ofs.yml'
    //         }
    //     }
    //     stage('OpenShift Installation') {
    //         steps {
    //                 sh 'ansible-playbook -i inventory.ini openshift-ansible/playbooks/prerequisites.yml'
    //                 sh 'ansible-playbook -i inventory.ini openshift-ansible/playbooks/deploy_cluster.yml'
    //         }
    //     }
    }
}