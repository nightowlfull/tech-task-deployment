#!/bin/sh

## This is newly created ec2 instance public IP.
PUBIP="$(cat PUBLIC_IP.TXT)"

## Working Directory of project.
PROJECT_PATH="$(pwd)"

ADMIN_PASS="${ADMIN_PASS}"

# Add Pem file path for the EC2 instance.
PEM_FILE_PATH="${PEM_FILE_PATH}"

# Add Github usernmae and password
GITHUB_USERNAME="${GITHUB_USERNAME}"
GITHUB_PASSWORD="${GITHUB_PASSWORD}"

## IP replaced in varibles file
sed -i 's/PUBLIC_IP/'$PUBIP'/g' ansible/variables.yml

## IP replaced in hosts file

sed -i 's/PUBLIC_IP/'$PUBIP'/g' ansible/hosts
## Pem file path replaced in hosts file

sed -i 's|AWS_PRIVATE_KEY_PATH|'$PEM_FILE_PATH'|g' ansible/hosts

sed -i 's|PROJECT_DIR|'$PROJECT_PATH'|g' ansible/variables.yml

sed -i 's/ADMIN_PASSWORD/'$ADMIN_PASS'/g' ansible/variables.yml

sed -i 's/ADMIN_PASSWORD/'$ADMIN_PASS'/g' ansible/setup-jenkins-cli.sh

sed -i 's|GIT_USERNAME|'$GITHUB_USERNAME'|g' ansible/cred.xml
sed -i 's|GIT_PASSWORD|'$GITHUB_PASSWORD'|g' ansible/cred.xml

echo "Instance Public IP is '$PUBIP' and configuration is updated.."