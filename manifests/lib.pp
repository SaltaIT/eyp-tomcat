define tomcat::lib (
                            $jar_name,
                            $source,
                            $catalina_base = "/opt/${name}",
                            $servicename   = $name,
                            $purge_old     = true,
                            $ensure        = 'present',
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
  else
  {
    $serviceinstance=undef
  }

  if($purge_old)
  {
    exec{ "purge old ${catalina_base} ${jar_name}":
      command     => "ls ${catalina_base}/lib/*jar | grep -v ${jar_name} | grep -E $(echo ${jar_name}.jar | sed 's/^\\(.*\\)-[0-9.]*\\.jar$/\\1/')'-[0-9.]+.jar' | xargs rm",
      onlyif      => "ls ${catalina_base}/lib/*jar | grep -v ${jar_name} | grep -E $(echo ${jar_name}.jar | sed 's/^\\(.*\\)-[0-9.]*\\.jar$/\\1/')'-[0-9.]+.jar'",
      notify      => $serviceinstance,
    }
  }

  file { "${catalina_base}/lib/${jar_name}.jar":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/lib"],
    source  => $source,
  }

}
