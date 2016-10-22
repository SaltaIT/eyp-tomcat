define tomcat::context (
                            $sessionCookiePath   = undef,
                            $session_cookie_name = undef,
                            $watchedResource     = 'WEB-INF/web.xml',
                            $manager             = '',
                            $antiJARLocking      = false,
                            $antiResourceLocking = false,
                            $servicename         = $name,
                            $catalina_base       = "/opt/${name}",
                            $path                = undef,
                            $inline              = false,
                            $docbase             = undef,
                            $reloadable          = undef,
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

  if($inline)
  {
    concat::fragment{ "${catalina_base}/conf/server.xml resource ${resource_type} ${resource_name}":
      target  => "${catalina_base}/conf/server.xml",
      order   => '11',
      content => template("${module_name}/serverxml/11_resource.erb"),
    }
  }
  else
  {
    concat { "${catalina_base}/conf/context.xml":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File["${catalina_base}/conf"],
      notify  => $serviceinstance,
    }

    concat::fragment{ "${catalina_base}/conf/context.xml header":
      target  => "${catalina_base}/conf/context.xml",
      order   => '00',
      content => template("${module_name}/conf/context.erb"),
    }

    concat::fragment{ "${catalina_base}/conf/server.xml fi context":
      target  => "${catalina_base}/conf/context.xml",
      order   => '99',
      content => "</Context>\n",
    }
  }
}
