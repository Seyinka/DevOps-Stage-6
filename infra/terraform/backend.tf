# Remote backend for management state
terraform {
    backend "s3" {
        bucket         = "devops-stage6-terraform-state-seyitan"  
        key            = "todo-app/terraform.tfstate"
        region         = "us-west-1"  
        encrypt        = true
        dynamodb_table = "terraform-state-lock"  
    }
}    