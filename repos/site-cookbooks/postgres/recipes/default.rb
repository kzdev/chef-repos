#
# Cookbook Name:: postgres
# Recipe:: default
#
# Copyright 2014, kzdev
#
# All rights reserved - Do Not Redistribute
#
package "postgresql-server" do
     action :install
end

dataDir = "/var/lib/pgsql/data/"
if not File.exists? dataDir then
   execute "postgresql-init" do
      command "service postgresql initdb"
   end
end

template "/var/lib/pgsql/data/pg_hba.conf" do
   mode 0600
end

template "/var/lib/pgsql/data/postgresql.conf" do
   mode 0600
end

service "postgresql" do
    action [:enable, :restart]
end

service "iptables" do
   action [:disable, :stop]
end
