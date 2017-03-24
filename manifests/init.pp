class cerebro (
  $version                = undef,
  $package_baseurl        = "https://github.com/lmenezes/cerebro/releases/download",
  $service_ensure         = 'running',
  $service_enable         = true,
  $java_install           = false,
  $java_package           = undef,
  $session_secret         = 'ki:s:[[@=Ag?QI`W2jMwkY:eqvrJ]JqoJyi2axj3ZvOv^/KavOT4ViJSv?6YY4[N',
  $elasticsearch_clusters = undef
) {
  anchor {'cerebro::begin': }

  $cerebro_user = 'cerebro'

  if $version == undef {
    fail "Please provide a valid version: ${title}::version"
  }
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
    package_url => "${package_baseurl}/v${version}/cerebro-${version}.zip",
  } ~>

  class { 'cerebro::config':
    session_secret         => $session_secret,
    elasticsearch_clusters => $elasticsearch_clusters
  } ->

  class { 'cerebro::service':
    enable => $service_enable,
    ensure => $service_ensure,
  }
}
