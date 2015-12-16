define tomcat::lib (
                            $catalina_base,
                            $source,
                            $servicename=undef,
                            $jar_name=$name,
                          ) {

  if ! defined(Class['tomcat'])
	{
		fail('You must include the tomcat base class before using any tomcat defined resources')
	}

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  file { "${catalina_base}/lib/${jar_name}.jar":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/lib"],
    notify  => $serviceinstance,
    source  => $source,
  }

}
