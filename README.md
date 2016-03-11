Kloudspeaker Cookbook
=====================
Installs and configures [Kloudspeaker](http://www.kloudspeaker.com), the feature-rich document management and sharing platform.

Requirements
------------
This cookbook has been tested on:

- CentOS 7
- Chef 12.6

Usage
-----
#### kloudspeaker::default
Installs Kloudspeaker, served by nginx and MariaDB. For more fine-grained control, you may pick from the recipes below instead.

#### kloudspeaker::application
Downloads the Kloudspeaker zip and installs it using the ark cookbook, under `/var/www/kloudspeaker` by default. It creates an `index.html` file based on attributes under `node['kloudspeaker']['client']`. It then creates a `configuration.php` file based on attributes under `node['kloudspeaker']['configuration']`.

If you wish to host your database on a different node then set the `db` attributes on that node instead, with the exception of `host`, which should be set on the application node. The application node will source the `db` attributes through a Chef search using the FQDN specified in `host`. You should therefore set up the database node first.

#### kloudspeaker::database
Creates a database with a dedicated user on your chosen backend. MySQL and PostgreSQL are currently supported by this recipe. A password for the user is randomly generated and saved to an attribute.

#### kloudspeaker::mariadb
Installs the MariaDB server, as well as the Ruby gem needed to create the database and user in the database recipe above. Certain `db` attributes are also prefilled appropriately.

Remember that the mariadb cookbook sets a blank root password by default so be sure to change it.

#### kloudspeaker::php
Installs PHP-FPM, as well as some required PHP extensions, including the relevant extension for your chosen database backend. To have it select the right backend automatically, execute the mariadb recipe first. This recipe is called by the nginx recipe below.

#### kloudspeaker::nginx
Installs and configures nginx to point to the PHP-FPM pool set up by the recipe above.

#### kloudspeaker::webdav
Downloads the Kloudspeaker WebDAV plugin zip and installs it using the ark cookbook, under `/var/www/kloudspeaker/backend/dav` by default. It creates an `index.php` file based on attributes under `node['kloudspeaker']['webdav']['configuration']`. The WebDAV URL defaults to `/backend/dav` but you can change the `BASE_URI` attribute to something more convenient like `/dav/`; don't forget the trailing slash here!

TODO
----
- Support more of the additional downloadable plugins
- mysql recipe (for using MySQL instead of MariaDB)
- postgresql recipe (does Kloudspeaker really support PostgreSQL?)
- apache recipe (for using Apache httpd instead of nginx)

Contributing
------------
You know what to do. ;)

License and Authors
-------------------
- Author:: James Le Cuirot (<james.le-cuirot@yakara.com>)

```text
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
```
