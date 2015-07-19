#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
# Installing Apache 2.2
package 'httpd-2.2.29-1.5.amzn1'

#Install WSGI for Apapche, required to run Graphite WSGI scripts
package 'mod_wsgi-python27-3.2-6.11.amzn1'

#Installing Cairo from epel repository
package 'python27-pycairo-1.8.6-2.1.11.amzn1' do
  options "--enablerepo=epel"
end

#Installing Cairo Development Packages from epel repository
package 'python27-pycairo-devel-1.8.6-2.1.11.amzn1' do
  options "--enablerepo=epel"
end

#Installing Twisted from epel repository
package 'python27-twisted-8.2.0-3.1.3.amzn1' do
  options "--enablerepo=epel"
end

#GCC is required for Pytz, installing
package 'gcc-4.8.2-3.19.amzn1'

#Installing Pytz
package 'python27-pytz-2010h-2.6.amzn1'

#Decide to use pip for Django so we can only use python 2.7, using PIP
#Installing Django
execute 'django_install' do
  command 'pip install django'
end

#Installing Django Tagging, same issue with Python 2.7, using PIP
execute 'django-tagging_install' do
  command 'pip install django-tagging'
end

#package 'pyparsing.noarch' do
execute 'pyparsing_install' do
  command 'pip install pyparsing'
end

#package 'python-whisper.noarch' do
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

template '/opt/graphite/conf/graphite.wsgi' do
  source 'graphite.wsgi.erb'
end

template '/opt/graphite/conf/storage-schemas.conf' do
  source 'storage-schemas.conf.erb'
end

template '/opt/graphite/conf/carbon.conf' do
  source 'carbon.conf.erb'
end

template '/root/chef_code/django_install.sh' do
  source 'django_install.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

installed_file_path = "/root/chef_code/django_installed_correctly"
uncompressed_file_dir = "/usr/local/lib/python2.7/site-packages/django/bin"
execute "install database" do
  command "/root/chef_code/django_install.sh"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

template '/etc/init.d/carbon-cache' do
  source 'carbon-cache.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

service 'carbon-cache' do
  supports :status => true
  action [:enable]
end

template '/opt/graphite/conf/storage-aggregation.conf' do
  source 'storage-aggregation.conf.erb'
  notifies :restart, 'service[carbon-cache]'
end

service 'httpd' do
  supports :status => true
  action [:enable]
end

template '/etc/httpd/conf.d/graphite-web.conf' do
  source 'graphite-web.conf.erb'
end

template '/etc/graphite-web/local_settings.py' do
  source 'local_settings.py.erb'
end

template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
end

template '/etc/httpd/conf/wsgi.conf' do
  source 'wsgi.conf.erb'
end



template '/var/www/error/error.html' do
  source 'error.html.erb'
end

template '/etc/httpd/conf.d/welcome.conf' do
  source 'welcome.conf.erb'
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
end

template '/root/chef_code/django_install.sh' do
  source 'django_install.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end



directory '/opt/graphite/storage/' do
  owner 'apache'
  group 'apache'
  recursive 'true'
end



service 'carbon-cache' do
  supports :status => true
  action [:enable, :restart]
end

service 'sshd' do
  supports :status => true
  action [:enable, :restart]
end
