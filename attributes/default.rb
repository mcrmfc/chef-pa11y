nodejs = platform_family == 'debian' ? '/usr/bin/node' : '/bin/node'
default['pa11y']['dashboard_port'] = 4000
default['pa11y']['webservice_port'] = 3000
default['pa11y']['linux']['home'] = '/usr/local/pa11y-dashboard'
default['pa11y']['linux']['node'] = nodejs
