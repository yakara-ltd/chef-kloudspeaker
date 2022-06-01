# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook:: kloudspeaker
# Recipe:: database
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

db = node['kloudspeaker']['configuration']['db'].to_hash

case db['type']
when 'mysql'
  # TODO: Use a local password attribute so that we can handle MySQL as well.
  db_connection = { host: 'localhost', password: node['mariadb']['server_root_password'] }
  db_provider = 'Mysql'
when 'postgresql'
  db_connection = { host: 'localhost' }
  db_provider = 'Postgresql'
else
  raise 'database recipe only supports the mysql and postgresql db types'
end

unless db['password']
  require 'securerandom'
  db['password'] = SecureRandom.urlsafe_base64
  node2 = Chef::Node.load node.name

  node.override['kloudspeaker']['configuration']['db']['password'] = db['password']
  node2.override['kloudspeaker']['configuration']['db']['password'] = db['password']
  node2.save
end

case db['type']
when 'mysql'

  mariadb_database db['database'] do
    host db_connection['host']
    action :create
  end

  mariadb_user db['user'] do
    host db_connection['host']
    database_name db['database']
    password db['password']
    host '%'
    action :grant
  end

# when 'postgresql'
#   postgresql_user db['user'] do
#     host db_connection["host"]
#     database_name db['database']
#     password db['password']

#     if db_provider == 'Mysql'
#       host '%'
#       action :grant
#     end
#   end

#   mariadb_database db['database'] do
#     host db_connection["host"]
#     owner db['user']
#   end
else
  raise 'database recipe only supports the mysql and postgresql db types'
end
