#!/bin/bash
echo "YO YO"
echo "installing git"
sudo yum install -y git
echo "installing chef"
rpm -ivh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.6.2-1.el6.x86_64.rpm
mkdir ~/chef_code/chef-repo
echo "Pulling down chef cookbooks for Graphite"
git clone git://github.com/chef/chef-repo.git ~/chef_code
chef-solo -c ~/chef_code/chef-solo/solo.rb
