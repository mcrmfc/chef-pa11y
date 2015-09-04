#
# Cookbook Name:: pa11y
# Recipe:: default
#
# Copyright (C) 2015 Matt Robbins
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mongodb3'
include_recipe 'nodejs'
include_recipe 'git'
include_recipe 'phantomjs::default'

git_client 'default' do
  action :install
end

user 'pa11y' do
  supports :manage_home => true
  comment 'pa11y user'
  home '/home/pa11y'
  shell '/bin/bash'
  password 'pa11y'
end

group 'pa11y' do
  action :create
  members 'pa11y'
  append true
end

directory "/usr/local/pa11y-dashboard" do
  owner 'pa11y'
  group 'pa11y'
  mode '0755'
  action :create
end

git '/usr/local/pa11y-dashboard' do
  repository 'https://github.com/nature/pa11y-dashboard.git'
  revision 'master'
  user 'pa11y'
  group 'pa11y'
  action :sync
end

nodejs_npm 'pa11y deps' do
  path "/usr/local/pa11y-dashboard"
  json true
  user 'pa11y'
end

template '/usr/local/pa11y-dashboard/config/development.json' do
  source 'development.json.erb'
  mode '0755'
  variables(
    dash_port: node['pa11y']['dashboard_port'],
    service_port: node['pa11y']['webservice_port']
  )
end

template '/usr/local/pa11y-dashboard/config/test.json' do
  source 'test.json.erb'
  mode '0755'
  variables(
    dash_port: node['pa11y']['dashboard_port'],
    service_port: node['pa11y']['webservice_port']
  )
end

template '/usr/local/pa11y-dashboard/config/production.json' do
  source 'production.json.erb'
  mode '0755'
  variables(
    dash_port: node['pa11y']['dashboard_port'],
    service_port: node['pa11y']['webservice_port']
  )
end

template '/etc/init.d/pa11y' do
  source "#{node['platform_family']}_initd.erb"
  mode '0755'
  variables(
    name: 'pa11y',
    dash_port: node['pa11y']['dashboard_port'],
    service_port: node['pa11y']['webservice_port'],
    node_path: node['pa11y']['linux']['node'],
    pa11y_path: node['pa11y']['linux']['home']
  )
  notifies :restart, "service[pa11y]"
end

service 'pa11y' do
  supports restart: true, reload: true, status: true
  action [:enable]
end

