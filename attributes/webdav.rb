#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: kloudspeaker
# Attributes:: webdav
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

default['kloudspeaker']['webdav']['version'] = '2.8'
default['kloudspeaker']['webdav']['checksum'] = '71d868d3fd2ede1717b5476088c8bd478b069e0917287fefc00f6355c461449e'
default['kloudspeaker']['webdav']['download_url'] = "https://dl.bintray.com/kloudspeaker/Kloudspeaker/kloudspeaker_webdav_#{node['kloudspeaker']['webdav']['version']}.zip"

default['kloudspeaker']['webdav']['configuration'] = {
  'KLOUDSPEAKER_BACKEND_ROOT' => "#{node['kloudspeaker']['dir']}/backend/",
  'BASE_URI' => '/backend/dav/',
  'ENABLE_LOCKING' => true,
  'ENABLE_BROWSER' => false,
  'ENABLE_TEMPORARY_FILE_FILTER' => true
}
