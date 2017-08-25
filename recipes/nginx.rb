#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: kloudspeaker
# Recipe:: nginx
#
# Copyright (C) 2017 Yakara Ltd
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

include_recipe 'chef_nginx'

# Give nginx permission to use the PHP socket.
node.default['kloudspeaker']['socket_group'] = node['nginx']['group']

include_recipe 'kloudspeaker::php'

config = node['kloudspeaker']['nginx'].to_hash
listen = config['directives']['listen']

# Find the listen prefix to allow SSL redirects. Unneeded for sockets.
if listen !~ /^unix:/ and listen =~ /\A(?<prefix>([^ ]+:)?)\d+\b/
  config['listen_prefix'] = $~[:prefix]
else
  config.delete('listen_prefix')
end

# Disable redirects if we're not using SSL.
config.delete('ssl_redirect') if listen !~ /\bssl\b/

template "#{node['nginx']['dir']}/sites-available/kloudspeaker" do
  source 'nginx-site.conf.erb'
  variables config
  helpers Chef::Kloudspeaker::Helpers
  notifies :reload, 'service[nginx]'

  owner 'root'
  group 'root'
  mode '0644'
end

nginx_site 'kloudspeaker'
