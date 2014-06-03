
package { 'vim':
  ensure => 'installed',
}

class { 'logstash':
  manage_repo  => true,
  repo_version => '1.3',
  install_contrib => true,
}

class { 'elasticsearch':
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb',
  config  => {
    'network.host' => '0.0.0.0',
  },
}

elasticsearch::plugin{'mobz/elasticsearch-head':
  module_dir => 'head'
}

class {'::mongodb::globals':
  manage_package_repo => true,
}->

class {'::mongodb::server':
  port    => 27017,
  verbose => true,
}

$secret = 'd74ff0ee8da3b9806b18c877dbf29bbde50b5bd8e4dad7a3a725000feb82e8f1'

class { 'graylog2::server':
  elasticsearch_cluster_name                         => 'elasticsearch',
  elasticsearch_discovery_zen_ping_multicast_enabled => false,
  root_password_sha256                               => 'f65208d0a72a22ef3db7dcb2af5d0f44f124b6b7e27d3bf4a289801e759f2dcd',
  password_secret                                    => $secret,
}

class { 'graylog2::web':
  application_secret => $secret,
}

file { '/etc/security/limits.d/elasticsearch.conf':
  content => "elasticsearch soft nofile 64000\nelasticsearch hard nofile 64000",
  owner   => 'root',
  group   => 'root',
  mode    => 644,
}
