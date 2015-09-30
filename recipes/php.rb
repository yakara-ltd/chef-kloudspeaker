#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: kloudspeaker
# Recipe:: php
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

# PHP package names differ.
php_prefix = value_for_platform_family(
  ['debian', 'suse'] => 'php5-',
  'default' => 'php-'
)

# Needed by the WebDAV plugin.
package ["#{php_prefix}mbstring", "#{php_prefix}xml"] do
  # mbstring and xml are built-in on Debian.
  not_if { platform_family?('debian') }
end

package "#{php_prefix}gd" do
  only_if { node['kloudspeaker']['configuration']['enable_thumbnails'] }
end

case database_config['type']
when 'mysql'
  package "#{php_prefix}mysql"
when 'pdo'
  package "#{php_prefix}pdo" do
    # Included in php5-common on Debian.
    not_if { platform_family?('debian') }
  end
when 'postgresql'
  package "#{php_prefix}pgsql"
when 'sqlite3'
  # Unavailable on RHEL. :(
  package "#{php_prefix}sqlite"
end

include_recipe 'php-fpm'

php_fpm_pool 'kloudspeaker' do
  user node['kloudspeaker']['user']
  group node['kloudspeaker']['group']
  listen_owner node['kloudspeaker']['user']
  listen_group node['kloudspeaker']['socket_group']

  php_options node['kloudspeaker']['php']['values'].sort.map { |key, value|
    ["php_value[#{key}]", value]
  }
end
