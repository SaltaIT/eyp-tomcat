define tomcat::lib (
                            $jar_name,
                            $source,
                            $catalina_base="/opt/${name}",
                            $servicename=$name,
                            $purge_old=true,
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
    $notify_jar=Exec["purge old ${catalina_base} ${jar_name}"]

    exec{ "purge old ${catalina_base} ${jar_name}":
      command     => "ls ${catalina_base}/lib/*jar | grep -v ${jar_name} | grep -E $(echo ${jar_name}.jar | sed 's/^\(.*\)-[0-9.]*\.jar$/\1/')'-[0-9.]+.jar' | xargs rm",
      refreshonly => true,
      notify      => $serviceinstance,
    }
  }
  else
  {
    $notify_jar=$serviceinstance
  }

  file { "${catalina_base}/lib/${jar_name}.jar":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/lib"],
    notify  => $notify_jar,
    source  => $source,
  }

}
