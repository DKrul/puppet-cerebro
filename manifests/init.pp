class cerebro (
  $version        = '0.5.1',
  $package_url    = "https://github.com/lmenezes/cerebro/releases/download/v${version}/cerebro-${version}.zip",
  $service_ensure = 'running',
  $service_enable = true,
  $java_install   = false,
  $java_package   = undef,
) {
  anchor {'cerebro::begin': }

  $cerebro_user = 'cerebro'

  if $java_install == true {
    # Install java
    class { '::java':
      package      => $java_package,
      distribution => 'jre',
    }

    # ensure we first install java, the package and then the rest
    Anchor['cerebro::begin']
    -> Class['::java']
    -> Class['cerebro::install']
  }

  class { 'cerebro::user':
    user => $cerebro_user,
  } ->

  class { 'cerebro::install':
    user        => $cerebro_user,
    version     => $version,
    package_url => $package_url,
  } ~>

  class { 'cerebro::service':
    enable => $service_enable,
    ensure => $service_ensure,
  }
}
