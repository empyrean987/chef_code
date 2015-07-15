#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
package 'httpd'
package 'mod_wsgi-python27.x86_64'
package 'python27-pycairo.x86_64'
  options "--enablerepo=epel"
end
package 'python27-pycairo-devel.x86_64' do
  options "--enablerepo=epel"
end
package 'Django14.noarch' od
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
package 'python27-pytz.noarch' do
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

#template '/etc/httpd/conf.d/graphite.conf' do
#  source 'graphite.conf.erb'
#end

#template '/opt/graphite/webapp/graphite/local_settings.py' do
#  source 'local_settings.py.erb'
#end

#template '/opt/graphite/conf/carbon.conf' do
#  source 'carbon.conf.erb'
#end

#template '/opt/graphite/conf/graphite.wsgi' do
#  source 'graphite.wsgi.erb'
#end


#service 'httpd' do
#  supports :status => true
#  action [:enable, :start]
#end
