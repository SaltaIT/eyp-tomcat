define tomcat::instance (
                          $tomcatpw,
                          $catalina_base          = "/opt/${name}",
                          $instancename           = $name,
                          $pwdigest               = 'sha',
                          $tomcat_user            = 'tomcat',
                          $server_info            = '.',
                          $server_number          = '.',
                          $server_built           = 'Long long ago',
                          $xmx                    = '512m',
                          $xms                    = '512m',
                          $maxpermsize            = '512m',
                          $permsize               = undef,
                          $shutdown_port          = '8005',
                          $ajp_port               = undef,
                          $connector_port         = '8080',
                          $jmx_port               = '8999',
                          $redirectPort           = '8443',
                          $realms                 = undef,
                          $values                 = undef,
                          $errorReportValveClass  = undef,
                          $maxThreads             = '150',
                          $minSpareThreads        = '4',
                          $connectionTimeout      = '20000',
                          $lockoutrealm           = true,
                          $userdatabase           = true,
                          $extra_vars             = undef,
                          $system_properties      = undef,
                          $rmi_server_hostname    = undef,
                          $catalina_rotate        = '15',
                          $catalina_size          = '100M',
                          $heapdump_oom_dir       = undef,
                          $install_tomcat_manager = true,
                          $shutdown_command       = 'SHUTDOWN',
                        ) {
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($realms)
  {
    validate_array($realms)
  }

  if($values)
  {
    validate_array($values)
  }

  validate_re($pwdigest, [ '^sha$', '^plaintext$'], 'Not a supported digest: sha/plaintext')

  if ($pwdigest=='sha')
  {
    $digestedtomcatpw=sha1($tomcatpw)
  }
  else
  {
    $digestedtomcatpw=$tomcatpw
  }

  if(defined(Class['java']))
  {
    $dependency_check_java=Class['java']
  }
  else
  {
    $dependency_check_java=undef
  }

  exec { "mkdir base tomcat instance ${instancename} ${catalina_base}":
    command => "mkdir -p ${catalina_base}",
    creates => $catalina_base,
    require => $dependency_check_java,
  }

  #mkdir -p $CATALINA_HOME/lib/org/apache/catalina/util
  exec { "mkdir ver tomcat instance ${instancename} ${catalina_base}":
    command => "mkdir -p ${catalina_base}/lib/org/apache/catalina/util",
    creates => "${catalina_base}/lib/org/apache/catalina/util",
  }

  file { $catalina_base:
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => Exec[
                    [
                      "mkdir base tomcat instance ${instancename} ${catalina_base}",
                      "mkdir ver tomcat instance ${instancename} ${catalina_base}"
                    ]
                  ],
  }

  file { "${catalina_base}/conf":
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File[$catalina_base],
  }

  file { "${catalina_base}/bin":
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File[$catalina_base],
  }

  file { "${catalina_base}/temp":
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File[$catalina_base],
  }

  file { "${catalina_base}/lib":
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File[$catalina_base],
  }

  file { "${catalina_base}/logs":
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File[$catalina_base],
  }

  file { "${catalina_base}/webapps":
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0775',
    require => File[$catalina_base],
  }

  concat { "${catalina_base}/conf/server.xml":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => Service[$instancename],
  }

  #content => template("${module_name}/serverxml.erb"),

  concat::fragment{ "${catalina_base}/conf/server.xml initxml":
    target  => "${catalina_base}/conf/server.xml",
    order   => '00',
    content => template("${module_name}/serverxml/00_initxml.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml server":
    target  => "${catalina_base}/conf/server.xml",
    order   => '01',
    content => template("${module_name}/serverxml/01_server.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml listeners":
    target  => "${catalina_base}/conf/server.xml",
    order   => '02',
    content => template("${module_name}/serverxml/02_listeners.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml service":
    target  => "${catalina_base}/conf/server.xml",
    order   => '20',
    content => template("${module_name}/serverxml/20_service.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml server end":
    target  => "${catalina_base}/conf/server.xml",
    order   => '99',
    content => template("${module_name}/serverxml/99_server_end.erb"),
  }

  if($userdatabase)
  {
    if(!defined(Concat::Fragment["${catalina_base}/conf/server.xml globalnamingresources ini"]))
    {
      concat::fragment{ "${catalina_base}/conf/server.xml globalnamingresources ini":
        target  => "${catalina_base}/conf/server.xml",
        order   => '10',
        content => template("${module_name}/serverxml/10_global_naming_resources_init.erb"),
      }
    }

    concat::fragment{ "${catalina_base}/conf/server.xml userdb resource":
      target  => "${catalina_base}/conf/server.xml",
      order   => '11',
      content => template("${module_name}/serverxml/11_user_db.erb"),
    }

    if(!defined(Concat::Fragment["${catalina_base}/conf/server.xml globalnamingresources end"]))
    {
      concat::fragment{ "${catalina_base}/conf/server.xml globalnamingresources end":
        target  => "${catalina_base}/conf/server.xml",
        order   => '12',
        content => template("${module_name}/serverxml/12_global_naming_resources_fi.erb"),
      }
    }

    file { "${catalina_base}/conf/tomcat-users.xml":
      ensure  => 'present',
      owner   => $tomcat_user,
      group   => $tomcat_user,
      mode    => '0644',
      require => File["${catalina_base}/conf"],
      notify  => Service[$instancename],
      content => template("${module_name}/tomcatusers.erb"),
    }
  }
  else
  {
    file { "${catalina_base}/conf/tomcat-users.xml":
      ensure  => 'absent',
      require => File["${catalina_base}/conf"],
      notify  => Service[$instancename],
    }
  }

  file { "${catalina_base}/bin/startup.sh":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File["${catalina_base}/bin"],
    content => template("${module_name}/multi/startup.erb"),
  }

  file { "${catalina_base}/bin/shutdown.sh":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File["${catalina_base}/bin"],
    content => template("${module_name}/multi/shutdown.erb"),
  }

  concat { "${catalina_base}/bin/setenv.sh":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0644',
    require => File["${catalina_base}/bin"],
    notify  => Service[$instancename],
  }

  concat::fragment{ "${catalina_base}/bin/setenv.sh base":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '00',
    content => template("${module_name}/multi/setenv.erb"),
  }

  if($extra_vars!=undef)
  {
    validate_hash($extra_vars)

    concat::fragment{ "${catalina_base}/bin/setenv.sh extravars":
      target  => "${catalina_base}/bin/setenv.sh",
      order   => '01',
      content => template("${module_name}/multi/setenv_extra_vars.erb"),
    }
  }

  if($system_properties!=undef)
  {
    validate_hash($system_properties)

    concat::fragment{ "${catalina_base}/bin/setenv.sh systemproperties":
      target  => "${catalina_base}/bin/setenv.sh",
      order   => '02',
      content => template("${module_name}/multi/setenv_systemproperties.erb"),
    }
  }

  concat::fragment{ "${catalina_base}/bin/setenv.sh jmx":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '02',
    content => template("${module_name}/multi/setenv_jmx.erb"),
  }


  if($server_info!=undef) or ($server_number!=undef) or ($server_built!=undef)
  {
    file { "${catalina_base}/lib/org/apache/catalina/util/ServerInfo.properties":
      ensure  => 'present',
      owner   => $tomcat_user,
      group   => $tomcat_user,
      mode    => '0644',
      require => File[$catalina_base],
      notify  => Service[$instancename],
      content => template("${module_name}/serverinfo.erb"),
      before  => File["/etc/init.d/${instancename}"],
    }
  }

  file { "/etc/init.d/${instancename}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [ File[ [
                        "${catalina_base}/conf/tomcat-users.xml",
                        "${catalina_base}/lib",
                        "${catalina_base}/logs",
                        "${catalina_base}/temp",
                        "${catalina_base}/bin",
                        "${catalina_base}/conf",
                        "${catalina_base}/webapps",
                        "${catalina_base}/bin/startup.sh",
                        "${catalina_base}/bin/shutdown.sh"
                      ] ],
                  Concat[ [ "${catalina_base}/bin/setenv.sh",
                            "${catalina_base}/conf/server.xml" ] ] ],
    content => template("${module_name}/multi/tomcat-init.erb"),
    notify  => Service[$instancename],
  }

  if($tomcat::params::systemd)
  {
    include systemd

    #TODO: canviar sistema d'arranc en CentOS7
    systemd::service { $instancename:
      execstart => "/etc/init.d/${instancename} start",
      execstop  => "/etc/init.d/${instancename} stop",
      require   => File["/etc/init.d/${instancename}"],
      before    => Service[$instancename],
      forking   => true,
      restart   => 'no',
      user      => 'tomcat',
      group     => 'tomcat',
    }
  }

  service { $instancename:
    ensure  => 'running',
    enable  => true,
    require => File["/etc/init.d/${instancename}"],
  }

  if($catalina_rotate!=undef)
  {
    if(defined(Class['::logrotate']))
    {
      logrotate::logs { "${instancename}.catalina.out":
        log          => "${catalina_base}/logs/catalina.out",
        compress     => true,
        copytruncate => true,
        frequency    => 'daily',
        rotate       => $catalina_rotate,
        missingok    => true,
        size         => $catalina_size,
      }
    }
  }

  if($install_tomcat_manager)
  {
    exec { "cp tomcat manager from tomcat-home ${instancename}":
      command => "cp -pr ${tomcat::catalina_home}/webapps/manager ${catalina_base}/webapps",
      creates => "${catalina_base}/webapps/manager",
      require => File["${catalina_base}/webapps"],
      before  => Service[$instancename],
    }

    exec { "cp tomcat host-manager from tomcat-home ${instancename}":
      command => "cp -pr ${tomcat::catalina_home}/webapps/host-manager ${catalina_base}/webapps",
      creates => "${catalina_base}/webapps/host-manager",
      require => File["${catalina_base}/webapps"],
      before  => Service[$instancename],
    }
  }

}
