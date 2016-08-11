#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: kloudspeaker
# Attributes:: nginx
#
# Copyright (C) 2015-2016 Yakara Ltd
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

default['kloudspeaker']['nginx']['directives']['access_log'] = "#{node['nginx']['log_dir']}/kloudspeaker.access.log"
default['kloudspeaker']['nginx']['directives']['client_max_body_size'] = '256m'
default['kloudspeaker']['nginx']['directives']['index'] = 'index.php index.html'
default['kloudspeaker']['nginx']['directives']['listen'] = '80'
default['kloudspeaker']['nginx']['directives']['root'] = node['kloudspeaker']['dir']
default['kloudspeaker']['nginx']['directives']['server_name'] = node['fqdn']

default['kloudspeaker']['nginx']['location']['directives'] = {}
default['kloudspeaker']['nginx']['location']['ordered_directives'] = []
default['kloudspeaker']['nginx']['ordered_directives'] = []
default['kloudspeaker']['nginx']['ssl_redirect'] = 443

default['nginx']['default_site_enabled'] = false
