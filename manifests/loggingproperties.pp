define tomcat::loggingproperties(
                                  $source,
                                  $catalina_base = "/opt/${name}",
                                  $servicename   = $name,
                                ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  file { "${catalina_base}/conf/logging.properties":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    source  => $source,
  }

}
