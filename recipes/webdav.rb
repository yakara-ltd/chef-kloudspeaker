#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: kloudspeaker
# Recipe:: webdav
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

include_recipe 'kloudspeaker::application'
dav_dir = node['kloudspeaker']['dir'] + '/backend/dav'

ark 'kloudspeaker-webdav' do
  version node['kloudspeaker']['webdav']['version']
  url node['kloudspeaker']['webdav']['download_url']
  checksum node['kloudspeaker']['webdav']['checksum']

  home_dir dav_dir
  prefix_root File.dirname node['kloudspeaker']['dir']
end

template "#{dav_dir}/index.php" do
  source 'webdav.php.erb'
  variables :configuration => node['kloudspeaker']['webdav']['configuration']
  helpers Chef::Kloudspeaker::Helpers

  owner 'root'
  group 'root'
  mode '0644'
end

# Directories to hold the locking data and TemporaryFileFilter
# files. Although the nginx rewrite rule will prevent normal browser
# access to these, it's best to be safe so lock them down.
%w( data temp ).each do |dir|
  directory "#{dav_dir}/#{dir}" do
    owner node['kloudspeaker']['user']
    group node['kloudspeaker']['group']
    mode '0750'
  end
end
