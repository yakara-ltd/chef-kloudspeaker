# frozen_string_literal: true

name             'kloudspeaker'
maintainer       'Nathan James'
maintainer_email 'nathan.james@yakara.com'
license          'Apache-2.0'
description      'Installs and configures Kloudspeaker'
version          '0.2.1'

chef_version '>= 17'

depends 'ark'
# depends 'database'
depends 'mariadb'
depends 'mysql2_chef_gem', '>= 2.0'
depends 'chef_nginx'
depends 'php-fpm'
depends 'selinux_policy'

supports 'centos'
