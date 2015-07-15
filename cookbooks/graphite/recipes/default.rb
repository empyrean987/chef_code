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

installed_file_path = "/usr/lib/python2.6/site-packages/django/__init__.pyc"
uncompressed_file_dir = "/usr/lib/python2.6/site-packages/django/bin/django-admin.py"
execute "install database" do
  command "PYTHONPATH=/usr/lib/python2.6/site-packages /usr/lib/python2.6/site-packages/django/bin/django-admin.py syncdb --settings=graphite.settings --noinput"
  cwd uncompressed_file_dir
  not_if { File.exists?(installed_file_path) }
end

service 'httpd' do
  supports :status => true
  action [:enable, :start]
end
