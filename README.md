# ForemanProbing
A plugin enabling Foreman to detect machines on the network and make the show up
as Hosts.

## Installation
The installation is split into four parts. General prerequisites and installing
Foreman, Smart Proxy and Smart Proxy Dynflow Core plugins

### Prerequisites
1. Install nmap
2. This assumes the following directory structure

```
$PROJECT_ROOT
+- foreman
+- foreman_probing
+- smart-proxy-probing
+- smart_proxy_dynflow
`- smart-proxy
```

### Installing the Foreman plugin
1. Clone this repository
2. Tell Foreman to load the gem

```shell
# In Foreman's checkout
cat <<-END > bundler.d/foreman_probing.rb
gem 'foreman_probing', :path => '../foreman_probing'
END
```

3. Run `bundle install`
4. Run the migrations and seeds

```shell
bundle exec rake db:migrate
bundle exec rake db:seed
```

### Installing the Smart Proxy plugin
1. Clone the `smart-proxy-probing` repository
2. Enable the plugin
```shell
# In smart-proxy checkout
cat <<-END > config/settings.d/probing.yml
---
:enabled: true
END

cat <<-END > bundler.d/smart-proxy-probing.rb
gem 'smart-proxy-probing', :path => '../smart-proxy-probing'
END
```
3. Run `bundle install`

### Installing the Smart Proxy Dynflow Core plugin
1. Clone this repository
2. Enable the plugin

```shell
# in smart_proxy_dynflow
cat <<-END > bundler.d/foreman_probing_core.rb
gem 'foreman_probing_core', :path => '../foreman_probing'
END
```

## Usage
1. Navigate to Monitor > Network scans
2. Click Run Scan
3. Fill out the form
4. Run the scan
5. Wait for it to finish
6. Observe Hosts created for the scanned machines
7. Use Remote Execution or Ansible to manage the hosts
8. (optional) Use Remote Execution or Ansible to deploy agents (Puppet, Katello,
   Chef, Salt minion...)
   
## Ansible roles
Some of the roles need `foreman_url` parameter to be set. It would be probably best to set this parameter as global and be done with it.

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *2017* *Adam Ruzicka*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

