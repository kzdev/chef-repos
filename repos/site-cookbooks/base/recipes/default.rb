#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'network' do
  user 'root'
  code <<-EOC
sed -i -e 's|HOSTNAME=.*$|HOSTNAME=#{node[:base][:fqdn]}|' /etc/sysconfig/network
  EOC
  not_if "grep -q #{node[:base][:fqdn]} /etc/sysconfig/network"
end

bash 'hostname' do
  user 'root'
  code <<-EOC
hostname `grep ^HOSTNAME /etc/sysconfig/network | sed 's/^.*=//'`
  EOC
  not_if "grep -q `hostname` /etc/sysconfig/network"
end

bash 'hosts' do
  user 'root'
  code <<-EOC
echo "`ifconfig eth1 | grep 'inet addr'|awk '{print $2}' | sed 's/^addr://'` `hostname` `hostname -s`" | tee -a /etc/hosts
  EOC
  not_if "grep -q `hostname` /etc/hosts"
end

bash 'selinux' do
  user 'root'
  code <<-EOC
cp -p /etc/sysconfig/selinux /etc/sysconfig/selinux.old
cat /etc/sysconfig/selinux.old | sed 's/^SELINUX=.*$/SELINUX=disabled/' > /etc/sysconfig/selinux
  EOC
  not_if "grep -q 'SELINUX=disabled' /etc/sysconfig/selinux"
end

bash 'fastestmirror' do
  user 'root'
  code <<-EOC
echo "include_only=.jp" | tee -a /etc/yum/pluginconf.d/fastestmirror.conf
  EOC
  not_if "grep -q ^'include_only=.jp' /etc/yum/pluginconf.d/fastestmirror.conf"
end

bash 'timezone' do
  user 'root'
  code <<-EOC
cp -p /etc/localtime /etc/localtime.old
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOC
  not_if "strings /etc/localtime | grep -q 'JST'"
end

bash 'locale' do
  user 'root'
  code <<-EOC
cp -p /etc/sysconfig/i18n /etc/sysconfig/i18n.old
cat /etc/sysconfig/i18n.old | sed 's/LANG.*$/LANG="ja_JP.utf8"/' > /etc/sysconfig/i18n
echo 'LC_ALL="ja_JP.UTF-8"' | tee -a /etc/sysconfig/i18n
  EOC
  not_if "grep -q ja_JP /etc/sysconfig/i18n"
end

template "/etc/sysconfig/iptables" do
  source "iptables"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, 'service[iptables]'
end

execute "yum.update" do
  command "yum -y update"
  action :run
end

user "kzdev" do
  comment "developer user"
  home "/home/kzdev"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
  action :create
end

# group management
group "rbenv" do
  action :modify
  members ['vagrant', 'kzdev']
end

# common-tools install
%w(vsftpd git wget httpd).each do |pkg|
  package pkg do
    action :install
  end
end

# language pack
bash "language pack" do
  user "root"
  code <<-EOH
yum -y groupinstall "Japanese Support"
localedef -f UTF-8 -i ja_JP ja_JP
  EOH
end
