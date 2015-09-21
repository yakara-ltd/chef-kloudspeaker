#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: kloudspeaker
# Attributes:: default
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

default['kloudspeaker']['version'] = '2.7.3'
default['kloudspeaker']['checksum'] = '2c29776c83919b19f68452e5115ae75e956cc1d6f823494d72e8f1909bcc637c'
default['kloudspeaker']['download_url'] = "https://github.com/sjarvela/kloudspeaker/releases/download/v#{node['kloudspeaker']['version']}/kloudspeaker_#{node['kloudspeaker']['version']}.zip"

default['kloudspeaker']['dir'] = '/var/www/kloudspeaker'
default['kloudspeaker']['user'] = 'kloudspeaker'
default['kloudspeaker']['group'] = 'kloudspeaker'
default['kloudspeaker']['socket_group'] = node['kloudspeaker']['group']

default['kloudspeaker']['configuration'] = {
  'enable_thumbnails' => false,
  'timezone' => 'UTC',
  'db' => {
    'host' => 'localhost',
    'user' => 'kloudspeaker',
    'database' => 'kloudspeaker'
  },
  'plugins' => {
    'ItemDetails' => [],
    'FileViewerEditor' => {
      'previewers' => {
        'Image' => ['gif', 'jpg', 'png']
      },
      'viewers' => {
        'Image' => ['gif', 'jpg', 'png']
      }
    }
  }
}

default['kloudspeaker']['client']['title'] = 'Example Kloudspeaker Page'

default['kloudspeaker']['client']['configuration'] = {
  'language' => {
    'default' => 'en'
  },
  'file-view' => {
    'list-view-columns' => {
      'name' => {
        'width' => 250
      },
      'size' => {},
      'file-modified' => {
        'width' => 150
      }
    }
  },
  'modules' => {
    'load' => ['kloudspeaker/ui/dropbox']
  },
  'plugins' => {
    'itemdetails' => {
      'filetypes' => {
        'jpg,tiff' => {
          'metadata-created' => {},
          'last-modified' => {},
          'size' => {},
          'exif' => {}
        },
        '*' => {
          'metadata-created' => {},
          'last-modified' => {},
          'size' => {}
        }
      }
    }
  }
}
