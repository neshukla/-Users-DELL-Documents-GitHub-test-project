Task1:-
Installed docker, Created three seperate containers for flask, npm and nginx and worked first individually on each to build and run the image. Once each image was built and ran successfully then checked if their URL is working fine. Once that done then worked on creating docker compose file and implemented that successfully.

Task2:-
Deployed all three containers into AWS using Terraform. Firstly worked on creating AWS instance, security group, cli and got everything working. Then worked on creating teraform variables, database components , main.tf and mentioned AWS and application related info in teraform code. Finally worked on to fix issues which I was getting on executing teraform init command and at last got it working. Below mentioning more details on what I have mentioned in my Teraform code:-

alb.tf:- It contains all the necessary resources to setup the Application Load Balancer. Firstly creation of security group for the ECS application. Here kept in my mind that traffic to ecs cluster should only come from the ALB. Then created the ALB, finally redirected traffic to applications through ALB
Resources:

network.tf:- It contains all the necessary resources to setup the basis for our ECS application and AWS environment. Here started with mentioning the Azs for the region. Then created VPC and IGW so that resources can talk to internet, created route table for VPC, Also as a good practise created a default route table for the VPC so that it can fall back to the default, then created public and private subnets in each availability zone. Then created db subnet group and associated the public and private subnets with the public route table. At last created security groups to provide access to private instances.

rds.tf:- It contains all the necessary resources to setup the RDS postgres database for the ECS application.

variables.tf:- Mentioned all the variables which will be used in main.tf

main.tf:- It contains only resources strictly related to deploying the application in ECS. Here created the ECS cluster and defined container tasks.

Task3:- For this task installed and started minikube and loaded the docker images. Then created deployment and services file for backend and frontend and mentioned loadbalancer and exposed port to 80 through services. 
