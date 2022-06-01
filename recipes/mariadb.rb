# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook:: kloudspeaker
# Recipe:: mariadb
#
# Copyright:: (C) 2015-2022 Yakara Ltd
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

# include_recipe 'mariadb::server'
# if platform_family?('rhel')
#   selinux_install 'default'
#   selinux_state 'enforcing'
# end

mariadb_repository 'install'

mariadb_server_install 'package' do
  action [:install, :create]
  # version node['mariadb_server_test_version']
  password 'gsql'
end

# Using this to generate a service resource to control
find_resource(:service, 'mariadb') do
  extend MariaDBCookbook::Helpers
  service_name lazy { platform_service_name }
  supports restart: true, status: true, reload: true
  action [:enable, :start]
end

# mysql2_chef_gem_mariadb 'default'
mariadb_client_install 'mariadb client'

node.default['kloudspeaker']['configuration']['db']['type'] = 'mysql'
node.default['kloudspeaker']['configuration']['db']['charset'] = 'utf8'
