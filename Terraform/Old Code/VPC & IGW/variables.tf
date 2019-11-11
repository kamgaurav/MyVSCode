#Define public key name & key path	

variable "public_key_path" {
	
	description = "Desired path of AWS key pair"
	
}

variable "key_name" {

  description = "Desired name of AWS key pair"
  
}


variable "aws_access_key" { }

variable "aws_secret_key" { }
