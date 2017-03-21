class cerebro::install (
  $version,
  $user,
  $package_url
) {
  $group = $user

  package { 'unzip':
    ensure => present
  }

  staging::deploy { "cerebro-${version}.zip":
    source  => $package_url,
    target  => '/opt',
    require => Package['unzip']
  } ->

  file { '/opt/cerebro':
    ensure => 'link',
    owner  => $user,
    group  => $group,
    target => "/opt/cerebro-${version}",
  } ->
  
  file { "/opt/cerebro-${version}":
    ensure => directory,
    owner  => $user,
    group  => $group
  } ->

  file { '/var/log/cerebro':
    ensure => link,
    owner  => $user,
    group  => $group,
    target => '/opt/cerebro/logs'
  }

  file { '/var/run/cerebro':
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  file { '/etc/tmpfiles.d/cerebro.conf':
    content => template('cerebro/etc/tmpfiles.d/cerebro.conf'),
  }

  file { '/etc/systemd/system/cerebro.service':
    content => template('cerebro/etc/systemd/system/cerebro.service'),
  }

  exec { "systemd_reload_${title}":
    command     => '/usr/bin/systemctl daemon-reload',
    subscribe   => File['/etc/systemd/system/cerebro.service'],
    refreshonly => true,
  }
}
