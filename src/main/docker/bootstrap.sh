#!/bin/sh

echo 'Saving message'
echo $1 > message.base64
echo 'Saved message'


echo 'Decoding message'
base64 -d message.base64 > message.json
echo 'Decoded message'

echo '***'
cat message.json
echo '***'

echo '****'
jq < message.json > messagepretty.json
echo '****'

echo '****'
cat messagepretty.json
echo '****'

export REPO_URL=`jq -r ".repository.clone_url" messagepretty.json`
echo 'REPO_URL=' $REPO_URL
export REPO_NAME=`jq -r ".repository.name" messagepretty.json`
echo 'REPO_NAME=' $REPO_NAME

export GIT_ASKPASS=no

git config --global credential.helper cache

echo 'Setting username'
#echo 'Setting username=' + $GH_USERNAME
git config --global credential.https://github.com.username $GH_USERNAME

echo 'Setting password'
#echo 'Setting password=' + $GH_PASSWORD
git config --global credential.https://github.com.password $GH_PASSWORD

echo 'Cloning!'
git clone $REPO_URL
echo 'Cloned!'

#echo 'Listing in directory=' $REPO_NAME
#find $REPO_NAME

#echo 'Argocd'
#argocd

#echo 'Try to launch workflow
#cd $REPO_NAME
#./build.sh

#nslookup argocd-server


#Install argocd cli
echo 'Installing ArgoCD-CLI'
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
mv argocd /usr/local/bin/argocd
echo 'Installed ArgoCD-CLI'

echo 'Logging into ArgoCD'
argocd login argocd-server.argocd
echo 'Logged into ArgoCD'


