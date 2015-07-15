#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
package 'httpd'
package 'mod_wsgi-python27.x86_64'
package 'python27-pycairo.x86_64' do
  options "--enablerepo=epel"
end
package 'python27-pycairo-devel.x86_64' do
  options "--enablerepo=epel"
end
package 'Django14.noarch' do
  options "--enablerepo=epel"
end
package 'python-django-tagging.noarch' do
  options "--enablerepo=epel"
end
package 'python27-twisted.noarch' do
  options "--enablerepo=epel"
end
package 'python-django15.noarch' do
  options "--enablerepo=epel"
end
package 'gcc'
package 'python27-pytz.noarch'
package 'pyparsing.noarch' do
  options "--enablerepo=epel"
end
package 'graphite-web.noarch' do
  options "--enablerepo=epel"
end
package 'python-carbon.noarch' do
  options "--enablerepo=epel"
end
package 'python-whisper.noarch' do
  options "--enablerepo=epel"
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

template '/etc/init.d/carbon-cache' do
  source 'carbon-cache.erb'
end

template '/var/www/error/error.html' do
  source 'error.html.erb'
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
end

installed_file_path = "/tmp/test"
uncompressed_file_dir = "/usr/lib/python2.6/site-packages/django/bin/django-admin.py"
execute "install database" do
  command "PYTHONPATH=/usr/lib/python2.6/site-packages /usr/lib/python2.6/site-packages/django/bin/django-admin.py syncdb --settings=graphite.settings --noinput"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

service 'httpd' do
  supports :status => true
  action [:enable, :restart]
end

service 'carbon-cache' do
  supports :status => true
  action [:enable, :restart]
end

service 'sshd' do
  supports :status => true
  action [:enable, :restart]
end
