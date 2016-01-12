define tomcat::authenticators (
                                $basic='org.apache.catalina.authenticator.BasicAuthenticator',
                                $form='org.apache.catalina.authenticator.FormAuthenticator',
                                $clientcert='org.apache.catalina.authenticator.SSLAuthenticator',
                                $digest='org.apache.catalina.authenticator.DigestAuthenticator',
                                $none='org.apache.catalina.authenticator.NonLoginAuthenticator',
                                $servicename=$name,
                                $catalina_base="/opt/${name}",
                              ) {

  if ! defined(Class['tomcat'])
	{
		fail('You must include the tomcat base class before using any tomcat defined resources')
	}

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  validate_string($basic)
  validate_string($form)
  validate_string($basic)
  validate_string($clientcert)
  validate_string($none)

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  exec { "mkdir p tomcat::authenticators ${name} ${catalina_base}":
    command => "mkdir -p ${catalina_base}/lib/org/apache/catalina/startup",
    creates => "${catalina_base}/lib/org/apache/catalina/startup",
  }

  file { "${catalina_base}/lib/org/apache/catalina/startup/Authenticators.properties":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [  Exec["mkdir p tomcat::authenticators ${name} ${catalina_base}"],
                  File["${catalina_base}/lib"]
                ],
    notify  => $serviceinstance,
    content => template("${module_name}/properties/authenticators.erb"),
  }

}
