define tomcat::jndi (
                            $ldapservers,
                            $ldapbase,
                            $ldapadmin,
                            $ldapadminpassword,
                            $servicename=$name,
                            $catalina_base="/opt/${name}",
                          ) {

  if ! defined(Class['tomcat'])
	{
		fail('You must include the tomcat base class before using any tomcat defined resources')
	}

  #validate_array($ldapservers)
  validate_string($ldapbase)

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  file { "${catalina_base}/conf/jndi.properties":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    content => template("${module_name}/properties/jndi.erb"),
  }

}
