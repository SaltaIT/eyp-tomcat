define tomcat::libstarball(
                            $source,
                            $catalina_base="/opt/${name}",
                            $servicename=$name,
                            $libstarballname=$name,
                            $purge_old=false,
                          ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  if($purge_old)
  {
    $notify_updated_tarball=Exec[ [ "cleanup ${libstarballname} ${catalina_base}",
                                    "tar xzf ${libstarballname} ${catalina_base}" ] ]

    exec { "cleanup ${libstarballname} ${catalina_base}":
      command     => "rm -fr ${catalina_base}/lib/* ${catalina_base}/lib/.*",
      refreshonly => true,
      notify      => Exec["tar xzf ${libstarballname} ${catalina_base}"],
      require     => File["${catalina_base}/.libs.${libstarballname}.tgz"],
      before      => Exec["tar xzf ${libstarballname} ${catalina_base}"],
    }
  }
  else
  {
    $notify_updated_tarball=Exec["tar xzf ${libstarballname} ${catalina_base}"]
  }

  file { "${catalina_base}/.libs.${libstarballname}.tgz":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    require => [File[$catalina_base], File["${catalina_base}/lib"]],
    notify  => $notify_updated_tarball,
    source  => $source,
  }

  exec { "tar xzf ${libstarballname} ${catalina_base}":
    command     => "tar --no-same-owner --strip 1 -xzf ${catalina_base}/.libs.${libstarballname}.tgz -C ${catalina_base}/lib",
    refreshonly => true,
    notify      => $serviceinstance,
    require     => File["${catalina_base}/.libs.${libstarballname}.tgz"],
  }

}
