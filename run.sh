#!/bin/bash
repository_ssh_url=git@github.com:mikaizhu/Speech-signal-processing.git
git remote set-url origin $repository_ssh_url
git add .
echo -n "input commit reason..."
read reason
git commit -m "$reason"
git push origin master
