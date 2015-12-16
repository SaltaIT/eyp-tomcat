define tomcat::context (
                            $sessionCookiePath=undef,
                            $WatchedResource='WEB-INF/web.xml',
                            $Manager='',
                            $antiJARLocking=false,
                            $antiResourceLocking=false,
                            $servicename=$name,
                            $catalina_base="/opt/${name}",
                          ) {

  if ! defined(Class['tomcat'])
	{
		fail('You must include the tomcat base class before using any tomcat defined resources')
	}

  #validate_array($ldapservers)
  #validate_string($ldapbase)

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  file { "${catalina_base}/conf/context.xml":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    content => template("${module_name}/conf/context.erb"),
  }

}
