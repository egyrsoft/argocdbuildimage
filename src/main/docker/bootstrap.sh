#!/bin/sh

export REPO_HTTPS_URL=$1
echo 'REPO_HTTPS_URL=' $REPO_HTTPS_URL
export REPO_SSH_URL=$2
echo 'REPO_SSH_URL=' $REPO_GIT_URL
export REPO_GIT_URL=$3
echo 'REPO_GIT_URL=' $REPO_GIT_URL
export REPO_NAME=$4
echo 'REPO_NAME=' $REPO_NAME
export COMMIT_ID=$5
echo 'COMMIT_ID=' $COMMIT_ID

#
# Checkout GIT
#
echo 'Setup for git'
mkdir /application/
cd /application/
#mkdir -p /root/.ssh/
#ls -alr /root/.ssh/
#cat /root/.ssh/ssh-privatekey
chmod u+x ~/.ssh/
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
#ls -ltr ~/.ssh/
#ls -ltr ~/.ssh/github_rsa/
ln -s ~/.ssh/github_rsa/ssh-privatekey ~/.ssh/id_rsa
ln -s ~/.ssh/github_rsa/ssh-publickey ~/.ssh/id_rsa.pub
#cat ~/.ssh/id_rsa
#cat ~/.ssh/id_rsa.pub
#ls -ltr ~/.ssh/

#
# Git cloning
#
echo 'Cloning!=' $REPO_SSH_URL
git clone $REPO_SSH_URL $REPO_NAME
echo 'Cloned!'

echo 'Checkout specific version'
cd $REPO_NAME
git checkout $COMMIT_ID
echo 'Checked specific version'

#
# Setup argo
#
# Download the binary
curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.2.4/argo-linux-amd64.gz
# Unzip
gunzip argo-linux-amd64.gz
# Make binary executable
chmod +x argo-linux-amd64
# Move binary to path
mv ./argo-linux-amd64 /usr/local/bin/argo
# Test installation
argo version

#
# Submit ARGOCD workflow
#
#cd $REPO_NAME
export WORKFLOW_FILE=".argocd/workflow.yaml"
if [ -f "$WORKFLOW_FILE" ]; then
    echo "$WORKFLOW_FILE exists."
    argo -k -s argo-server.argo:2746 --serviceaccount operate-workflow-sa submit .argocd/workflow.yaml
else
    echo "$WORKFLOW_FILE doesn't exist."
fi

