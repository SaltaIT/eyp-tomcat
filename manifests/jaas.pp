define tomcat::jaas (
                            $app,
                            $provider,
                            $filter,
                            $username='tomcat',
                            $password='tomcat',
                            $servicename=$name,
                            $catalina_base="/opt/${name}",
                          ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  file { "${catalina_base}/conf/jaas.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    content => template("${module_name}/conf/jaas.erb"),
  }

  concat::fragment{ "${catalina_base}/bin/setenv.sh jaas":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '00',
    content => template("${module_name}/multi/setenv_jaas.erb"),
  }

}
