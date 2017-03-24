class cerebro::config (
  $session_secret,
  $elasticsearch_clusters
) {

  file { '/opt/cerebro/conf/application.conf':
    content => template('cerebro/application.conf.erb'),
    notify  => Service['cerebro']
  }
}
