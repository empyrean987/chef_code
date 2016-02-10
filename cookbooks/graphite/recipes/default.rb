#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
# Installing Apache 2.2
package 'httpd' do
    version '2.2.31-1.6.amzn1
end

#Install WSGI for Apapche, required to run Graphite WSGI scripts
package 'mod_wsgi-python27' do
    version '3.2-6.11.amzn1'
end

#Installing Cairo from epel repository
package 'python27-pycairo' do
  options '--enablerepo=epel'
  version '1.8.6-2.1.11.amzn1'
end

#Installing Cairo Development Packages from epel repository
package 'python27-pycairo-devel' do
  options '--enablerepo=epel'
  version '1.8.6-2.1.11.amzn1'
end

#Installing Twisted from epel repository
package 'python27-twisted' do
  options '--enablerepo=epel'
  version '8.2.0-3.1.3.amzn1'
end

#GCC is required for Pytz, installing
package 'gcc' do
  version '4.8.2-3.19.amzn1'
end
#Installing Pytz
package 'python27-pytz' do
  version '2010h-2.6.amzn1'
end
#Decide to use pip for Django so we can only use python 2.7, using PIP
#Installing Django
execute 'django_install' do
  command 'pip install django'
end

#Installing Django Tagging, same issue with Python 2.7, using PIP
execute 'django-tagging_install' do
  command 'pip install django-tagging'
end

#Installing Pyparsing, same issue with Python 2.7, using PIP
execute 'pyparsing_install' do
  command 'pip install pyparsing'
end

#Installing Whisper, same issue with Python 2.7, using PIP
execute 'whisper_install' do
  command 'pip install whisper'
end

#Installing Graphite Web
execute 'graphite-web_install' do
  command 'pip install graphite-web'
end

#Installing Carbon
execute 'carbon_install' do
  command 'pip install carbon'
end

#Script to install database, needs to be executable and ran by root
template '/root/chef_code/django_install.sh' do
  source 'django_install.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

#This file has the keyword installed if the datbase was installed correctly
installed_file_path = "/root/chef_code/django_installed_correctly"
#This defines where the django admin script is that will be used to install the database
uncompressed_file_dir = "/usr/local/lib/python2.7/site-packages/django/bin"
#This is the execution of installing the django database and ensuring it installed correctly
execute "install database" do
  command "/root/chef_code/django_install.sh"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

#This is the startup script fro carbon-cache
template '/etc/init.d/carbon-cache' do
  source 'carbon-cache.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
#This sets the carb-cache service to be enabled in the operating system to be started on restart
service 'carbon-cache' do
  supports :status => true, :reload => true, :start => true, :restart =>true, :stop =>true
  action [:enable]
end

#Configuration file for storage schemas, restart carbon-cache if modified
template '/opt/graphite/conf/storage-schemas.conf' do
  source 'storage-schemas.conf.erb'
  notifies :reload, 'service[carbon-cache]', :delayed
end

#Configuration file for carbon, restart carbon-cache if modified
template '/opt/graphite/conf/carbon.conf' do
  source 'carbon.conf.erb'
  notifies :reload, 'service[carbon-cache]', :delayed
end

#Configuration file for storage aggregation, restart carbon-cache if modified
template '/opt/graphite/conf/storage-aggregation.conf' do
  source 'storage-aggregation.conf.erb'
  notifies :reload, 'service[carbon-cache]', :delayed
end

#Making sure carbon-cache is started after first install, otherwise makes sure its running
service 'carbon-cache' do
  supports :status => true, :reload => true, :start => true, :restart =>true, :stop =>true
  action [:start]
end

#Modify /opt/graphite/storage to be owned and grouped by apache, could not use directory resource
execute 'fix_ownership' do
  command 'chown -R apache:apache /opt/graphite/storage/'
end

#The graphite.wsgi need to be created for graphite to work
template '/opt/graphite/conf/graphite.wsgi' do
  source 'graphite.wsgi.erb'
end

#The error.html file need to be created for when a disallowed ip address trys to access website
template '/var/www/error/error.html' do
  source 'error.html.erb'
end

#Configuration file for graphite-web python application
template '/opt/graphite/webapp/graphite/local_settings.py' do
  source 'local_settings.py.erb'
end

#This sets the httpd service to be enabled in the operating system to be started on restart
service 'httpd' do
  supports :status => true, :reload => true, :start => true, :restart =>true, :stop =>true
  action [:enable]
end

#This file needs to be commented out so it no longer is reference by apache
template '/etc/httpd/conf.d/welcome.conf' do
  source 'welcome.conf.erb'
  notifies :reload, 'service[httpd]', :delayed
end

#This is the configuration file for the web portion of graphite
template '/etc/httpd/conf.d/graphite-web.conf' do
  source 'graphite-web.conf.erb'
  notifies :reload, 'service[httpd]', :delayed
end

#This is the conifguration file for apache to work correctly
#template '/etc/httpd/conf/httpd.conf' do
#  source 'httpd.conf.erb'
#  notifies :reload, 'service[httpd]', :delayed
#end

#This is the conifguration file for apache to work correctly withy wsgi
template '/etc/httpd/conf/wsgi.conf' do
  source 'wsgi.conf.erb'
  notifies :reload, 'service[httpd]', :delayed
end

service 'httpd' do
  action [:start]
end

#This sets the sshd service to be enabled in the operating system to be started on restart
#service 'sshd' do
#  supports :status => true, :reload => true, :start => true, :restart =>true, :stop =>true
#  action [:enable]
#end

#Template to modify sshd configuration, and on moidification restart
#template '/etc/ssh/sshd_config' do
#  source 'sshd_config.erb'
#  notifies :reload, 'service[sshd]', :delayed
#end
