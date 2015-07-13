#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
package 'httpd'
service 'httpd' do
  supports :status => true
  action [:enable, :start]
end

package 'mod_wsgi-python27.x86_64'
package 'git'
package 'python27-pycairo-devel.x86_64'
package 'python27-pip'
package 'gcc'
package 'python27-pytz.noarch'
#python_pip "django" do
#  action :install
#end

git "/root/chef_code/carbon" do
  repository "https://github.com/graphite-project/carbon.git"
  revision "master"
  action :sync
end

git "/root/chef_code/graphite-web" do
  repository "https://github.com/graphite-project/graphite-web.git"
  revision "master"
  action :sync
end

git "/root/chef_code/whisper" do
  repository "https://github.com/graphite-project/whisper.git"
  revision "master"
  action :sync
end

git "/root/chef_code/twisted" do
  repository "https://github.com/twisted/twisted.git"
  revision "trunk"
  action :sync
end

git "/root/chef_code/django" do
  repository "https://github.com/django/django.git"
  revision "master"
  action :sync
end

git "/root/chef_code/pyparsing" do
  repository "https://github.com/greghaskins/pyparsing.git"
  revision "master"
  action :sync
end

git "/root/chef_code/tagging" do
  repository "https://github.com/brosner/django-tagging.git"
  revision "master"
  action :sync
end

installed_file_path = "/opt/graphite/bin/"
uncompressed_file_dir = "/root/chef_code/carbon"
execute "install carbon" do
  command "python setup.py install"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

installed_file_path = "/opt/graphite/webapp/"
uncompressed_file_dir = "/root/chef_code/graphite-web"
execute "install graphite-web" do
  command "python setup.py install"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

installed_file_path = "/usr/local/lib/python2.7/site-packages/whisper-0.9.10.egg-info"
uncompressed_file_dir = "/root/chef_code/whisper"
execute "install whisper" do
  command "python setup.py install"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

installed_file_path = "/usr/local/lib64/python2.7/site-packages/Twisted-15.2.1-py2.7-linux-x86_64.egg"
uncompressed_file_dir = "/root/chef_code/twisted"
execute "install twisted" do
  command "python setup.py install"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

installed_file_path = "/usr/local/lib/python2.7/site-packages/Django-1.9.dev20150712174416-py2.7.egg"
uncompressed_file_dir = "/root/chef_code/django"
execute "install django" do
  command "python setup.py install"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

installed_file_path = "/usr/local/lib/python2.7/site-packages/pyparsing-1.5.6.egg-info"
uncompressed_file_dir = "/root/chef_code/pyparsing/src"
execute "install pyparsing" do
  command "python setup.py install"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

installed_file_path = "/usr/local/lib/python2.7/site-packages/django_tagging-0.4.dev1.egg-info"
uncompressed_file_dir = "/root/chef_code/tagging"
execute "install tagging" do
  command "python setup.py install"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

template '/etc/httpd/conf.d/graphite.conf' do
  source 'graphite.conf.erb'
end

template '/opt/graphite/webapp/graphite/local_settings.py' do
  source 'local_settings.py.erb'
end

template '/opt/graphite/conf/carbon.conf' do
  source 'carbon.conf.erb'
end

template '/opt/graphite/conf/graphite.wsgi' do
  source 'graphite.wsgi.erb'
end


service 'httpd' do
  action :restart
end
