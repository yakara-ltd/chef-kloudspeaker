#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: kloudspeaker
# Recipe:: application
#
# Copyright (C) 2015 Yakara Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

extend Chef::Kloudspeaker::Helpers

package ['unzip', 'rsync']

group node['kloudspeaker']['group'] do
  system true
end

user node['kloudspeaker']['user'] do
  gid node['kloudspeaker']['group']
  shell '/usr/sbin/nologin'
  home '/dev/null'
  system true
end

ark 'kloudspeaker' do
  version node['kloudspeaker']['version']
  url node['kloudspeaker']['download_url']
  checksum node['kloudspeaker']['checksum']

  home_dir node['kloudspeaker']['dir']
  prefix_root File.dirname node['kloudspeaker']['dir']
end

template "#{node['kloudspeaker']['dir']}/index.html" do
  source 'index.html.erb'
  variables node['kloudspeaker']['client']
  helpers ERB::Util

  owner 'root'
  group 'root'
  mode '0644'
end

config = node['kloudspeaker']['configuration'].to_hash
config['db'].merge! database_config

template "#{node['kloudspeaker']['dir']}/backend/configuration.php" do
  source 'configuration.php.erb'
  variables :configuration => config
  helpers Chef::Kloudspeaker::Helpers

  owner 'root'
  group node['kloudspeaker']['group']
  mode '0640'
end
