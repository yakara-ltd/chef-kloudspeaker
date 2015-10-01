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

extend SELinuxPolicy::Helpers
include_recipe 'selinux_policy::install' if use_selinux

include_recipe 'kloudspeaker::application'
dav_dir = node['kloudspeaker']['dir'] + '/backend/dav'

ark_resource = ark 'kloudspeaker-webdav' do
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

# Directories for locking data and TemporaryFileFilter files.
%w( data temp ).each do |dir|
  # Allow writing to these directories under SELinux. Note that we
  # have to use the real versioned path as symlinks are not honoured.
  selinux_policy_fcontext "#{Regexp.escape dav_dir}/#{dir}(/.*)?" do
    file_spec lazy { "#{Regexp.escape ark_resource.path}/#{dir}(/.*)?" }
    secontext 'httpd_sys_rw_content_t'
  end

  # Although the nginx rewrite rule will prevent normal browser access
  # to these directories, it's best to be safe so lock them down.
  directory "#{dav_dir}/#{dir}" do
    owner node['kloudspeaker']['user']
    group node['kloudspeaker']['group']
    mode '0750'
  end
end
