#!/bin/bash
echo "YO YO"
echo "Updating OS"
sudo yum update -y
echo "verifying git"
rpm -qa | grep git > git.txt
if [ -s git.txt ]
then
  echo "git installed"
else
  echo "installing git"
  sudo yum install -y git
fi
echo "verifying chef"
rpm -qa | grep chef > chef.txt
if [ -s chef.txt ]
then
  echo " chef is installed"
else
  echo "installing chef"
  rpm -ivh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.6.2-1.el6.x86_64.rpm
fi
echo "Pulling down chef cookbooks for Graphite"
chef-solo -c ~/chef_code/chef-solo/solo.rb
