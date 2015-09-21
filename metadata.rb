name             'kloudspeaker'
maintainer       'James Le Cuirot'
maintainer_email 'james.le-cuirot@yakara.com'
license          'Apache 2.0'
description      'Installs and configures Kloudspeaker'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'ark'
depends 'database'
depends 'mariadb'
depends 'mysql2_chef_gem'
depends 'nginx', '<3'
depends 'php-fpm'

supports 'centos'