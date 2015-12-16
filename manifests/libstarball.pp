define tomcat::libstarball (
                            $catalina_base="/opt/${name}",
                            $source,
                            $servicename=$name,
                            $libstarballname=$name,
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

  file { "${catalina_base}/.libs.${libstarballname}.tgz":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    require => [File[$catalina_base], File["${catalina_base}/lib"]],
    notify  => Exec["tar xzf ${libstarballname} ${catalina_base}"],
    source  => $source,
  }

  exec { "tar xzf ${libstarballname} ${catalina_base}":
    command => "tar --no-same-owner --strip 1 -xzf ${catalina_base}/.libs.${libstarballname}.tgz -C ${catalina_base}/lib",
    refreshonly => true,
    notify  => $serviceinstance,
    require => File["${catalina_base}/.libs.${libstarballname}.tgz"],
  }

}
