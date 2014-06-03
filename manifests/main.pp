
class { 'logstash':
  manage_repo  => true,
  repo_version => '1.3',
  install_contrib => true,
}

# file { '/usr/share/elasticsearch':
#   ensure  => 'directory',
#   owner   => 'elasticsearch',
#   group   => 'elasticsearch',
#   mode    => '0755',
# }->

class { 'elasticsearch':
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb',
  config  => {
    'network.host' => '0.0.0.0',
  },
}
