class cerebro (
  $version        = '0.5.1',
  $package_url    = "https://github.com/lmenezes/cerebro/releases/download/v${version}/cerebro-${version}.zip",
  $service_ensure = 'running',
  $service_enable = true,
) {

  $cerebro_user = 'cerebro'

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
