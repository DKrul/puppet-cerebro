class cerebro::install (
  $version,
  $user,
  $package_url = "https://github.com/lmenezes/cerebro/releases/download/v${version}/cerebro-${version}.zip",
) {
  $group = $user

  package { 'unzip':
    ensure => present
  }
  staging::deploy { "cerebro-${version}.zip":
    source  => $package_url,
    target  => '/opt',
    user    => $user,
    group   => $group,
    require => Package['unzip']
  } ->

  file { '/opt/cerebro':
    ensure => 'link',
    owner  => $user,
    group  => $group,
    target => "/opt/cerebro-${version}",
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
