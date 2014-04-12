# dependencies rpm install
%w{openssl-devel readline-devel zlib-devel curl-devel
   libyaml-devel httpd httpd-devel apr-devel apr-util-devel}.each do |p|
  package p do
    action :install
  end
end

# gem install
gem_package "passenger" do
  action :install
end

# passenger install for apache
#execute "passenger.install" do
#  command "passenger-install-apache2-module --auto"
#  action :run
#end
