# Update system packages
sudo yum update -y

# Install required dependencies
sudo yum install -y ruby wget

# Install AWS CodeDeploy agent
cd ~
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Check CodeDeploy agent status
sudo service codedeploy-agent status
