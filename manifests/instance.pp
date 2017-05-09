#
# concat server.xml
# 00 - init xml
# 05 - server tag
# 06 - listeners
# 10 - globalnaming
# 11 - userdb
# 11 - resource pools
# 15 - end globalnaming
# 20 - connectors
# 21 - engine
# 22 - realms - combined realm and optionally userdatabase wiht lockoutrealm
# 23 - **other realms**
# 24 - end realms
# 25 - host
# 26 - context
# 27 - end host
# 30 - end engine - end service
# 99 - end server
#
# concat tomcat-users.xml
# 00 - header
# 44 - roles
# 55 - users
# 99 - end tag
define tomcat::instance (
                          $tomcatpw                              = 'password',
                          $catalina_base                         = "/opt/${name}",
                          $pid_file                              = "/var/run/${name}.pid",
                          $instancename                          = $name,
                          $pwdigest                              = 'sha',
                          $tomcat_user                           = $tomcat::params::default_tomcat_user,
                          $server_info                           = '.',
                          $server_number                         = '.',
                          $server_built                          = 'Long long ago',
                          $xmx                                   = '512m',
                          $xms                                   = '512m',
                          $maxpermsize                           = '512m',
                          $permsize                              = undef,
                          $shutdown_port                         = '8005',
                          $shutdown_address                      = '127.0.0.1',
                          $ajp_port                              = undef,
                          $connector_ajp_packet_size             = undef,
                          $connector_port                        = '8080',
                          $connector_http_server                 = undef,
                          $connector_http_max_header_size        = undef,
                          $connector_http_max_threads            = undef,
                          $connector_http_min_spare_threads      = undef,
                          $connector_http_max_spare_threads      = undef,
                          $connector_http_enable_lookups         = false,
                          $connector_http_accept_count           = undef,
                          $connector_http_connection_timeout     = '20000',
                          $connector_http_disable_upload_timeout = true,
                          $connector_http_uri_encoding           = undef,
                          $jmx_port                              = '8999',
                          $redirect_port                         = '8443',
                          $realms                                = undef,
                          $values                                = undef,
                          $max_threads                           = '150',
                          $min_spare_threads                     = '4',
                          $lockoutrealm                          = true,
                          $userdatabase                          = true,
                          $extra_vars                            = undef,
                          $system_properties                     = undef,
                          $rmi_server_hostname                   = undef,
                          $catalina_rotate                       = '15',
                          $catalina_size                         = '100M',
                          $catalina_logrotate_ensure             = 'present',
                          $heapdump_oom_dir                      = undef,
                          $install_tomcat_manager                = true,
                          $shutdown_command                      = hiera('eyptomcat::shutdowncommand', 'SHUTDOWN'),
                          $java_library_path                     = undef,
                          $java_home                             = undef,
                          $webapps_owner                         = $tomcat::params::default_tomcat_user,
                          $webapps_group                         = $tomcat::params::default_tomcat_user,
                          $webapps_mode                          = $tomcat::params::default_webapps_mode,
                          $ensure                                = 'running',
                          $manage_service                        = true,
                          $manage_docker_service                 = true,
                          $enable                                = true,
                          $xml_validation                        = undef,
                          $xml_namespace_aware                   = undef,
                          $jvm_route                             = undef,
                          $version_logger_listener               = true,
                          $jasper_listener                       = true,
                          $enable_default_access_log             = true,
                          $custom_webxml                         = false,
                          $add_error_report_valve_settings       = true,
                          $error_report_valve_show_report        = false,
                          $error_report_valve_show_server_info   = false,
                          $error_report_valve_class              = 'org.apache.catalina.valves.ErrorReportValve',
                          $user_language                         = undef,
                          $user_region                           = undef,
                          $user_country                          = undef,
                          $user_variant                          = undef,
                          $file_encoding                         = undef,
                          $sun_jnu_encoding                      = undef,
                          $file_encoding_pkg                     = undef,
                          $umask                                 = undef,
                          $xmns                                  = undef,
                          $xmnx                                  = undef,
                          $use_concurrent_mark_sweep             = true,
                          $cms_initiating_occupancy_fraction     = undef,
                          $disable_explicit_gc                   = false,
                          $max_gc_pause_millis                   = undef,
                          $print_gc                              = false,
                          $print_gc_details                      = false,
                          $print_gc_datestamps                   = false,
                          $print_gc_application_stopped_time     = false,
                        ) {
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  # obtenir versio tomcat instalada al tomcathome
  #
  # # /opt/tomcat-home/bin/version.sh  | grep "Server version" | rev | cut -f 1 -d/ | rev
  # 8.5.11
  # /opt/tomcat-home/bin/version.sh  | grep "Server version" | awk -F/ '{ print $NF }'
  # 8.5.11


  if($tomcatpw=='password')
  {
    fail("Please change default password for tomcat instance: ${instancename}")
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

  if(defined(Class['java']))
  {
    $dependency_check_java=Class['java']
  }
  else
  {
    $dependency_check_java=undef
  }

  validate_bool($manage_docker_service)
  validate_bool($manage_service)
  validate_bool($enable)

  validate_re($ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

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
    owner   => $webapps_owner,
    group   => $webapps_group,
    mode    => $webapps_mode,
    require => File[$catalina_base],
  }

  file { "${catalina_base}/conf/sites":
    ensure  => 'directory',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File["${catalina_base}/conf"],
  }

  concat { "${catalina_base}/conf/server.xml":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => Tomcat::Instance::Service[$instancename],
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
    content => template("${module_name}/serverxml/05_server.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml listeners":
    target  => "${catalina_base}/conf/server.xml",
    order   => '02',
    content => template("${module_name}/serverxml/06_listeners.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml connectors":
    target  => "${catalina_base}/conf/server.xml",
    order   => '20',
    content => template("${module_name}/serverxml/20_connectors.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml engine":
    target  => "${catalina_base}/conf/server.xml",
    order   => '21',
    content => template("${module_name}/serverxml/21_engine.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml default realms":
    target  => "${catalina_base}/conf/server.xml",
    order   => '22',
    content => template("${module_name}/serverxml/22_default_realms.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml end realms":
    target  => "${catalina_base}/conf/server.xml",
    order   => '24',
    content => template("${module_name}/serverxml/24_endrealms.erb"),
  }

  #
  # default vhost
  #

  concat::fragment{ "${catalina_base}/conf/server.xml host":
    target  => "${catalina_base}/conf/server.xml",
    order   => '25',
    content => template("${module_name}/serverxml/25_host.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/server.xml end host":
    target  => "${catalina_base}/conf/server.xml",
    order   => '27',
    content => "        </Host>\n",
  }

  #
  # end default vhost
  #

  concat::fragment{ "${catalina_base}/conf/server.xml end service":
    target  => "${catalina_base}/conf/server.xml",
    order   => '30',
    content => template("${module_name}/serverxml/30_endservice.erb"),
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
        order   => '15',
        content => template("${module_name}/serverxml/15_global_naming_resources_fi.erb"),
      }
    }

    concat { "${catalina_base}/conf/tomcat-users.xml":
      ensure  => 'present',
      owner   => $tomcat_user,
      group   => $tomcat_user,
      mode    => '0644',
      require => File["${catalina_base}/conf"],
      notify  => Tomcat::Instance::Service[$instancename],
      before  => File["/etc/init.d/${instancename}"],
    }

    concat::fragment{ "${catalina_base}/conf/tomcat-users.xml head":
      target  => "${catalina_base}/conf/tomcat-users.xml",
      order   => '00',
      content => template("${module_name}/tomcatusers.erb"),
    }

    # tomcat user
    tomcat::tomcatuser { "${instancename} tomcat user":
      tomcatuser    => 'tomcat',
      password      => $tomcatpw,
      catalina_base => $catalina_base,
      servicename   => $instancename,
      pwdigest      => $pwdigest,
      roles         => [ 'tomcat', 'manager', 'admin', 'manager-gui' ],
    }

    # <role rolename="tomcat"/>
    # <role rolename="manager"/>
    # <role rolename="admin"/>
    # <role rolename="manager-gui"/>

    tomcat::tomcatrole { "${instancename} tomcat role tomcat":
      rolename      => 'tomcat',
      catalina_base => $catalina_base,
      servicename   => $instancename,
    }

    tomcat::tomcatrole { "${instancename} tomcat role manager":
      rolename      => 'manager',
      catalina_base => $catalina_base,
      servicename   => $instancename,
    }

    tomcat::tomcatrole { "${instancename} tomcat role admin":
      rolename      => 'admin',
      catalina_base => $catalina_base,
      servicename   => $instancename,
    }

    tomcat::tomcatrole { "${instancename} tomcat role manager-gui":
      rolename      => 'manager-gui',
      catalina_base => $catalina_base,
      servicename   => $instancename,
    }

    concat::fragment{ "${catalina_base}/conf/tomcat-users.xml end":
      target  => "${catalina_base}/conf/tomcat-users.xml",
      order   => '99',
      content => "</tomcat-users>\n",
    }
  }
  else
  {
    file { "${catalina_base}/conf/tomcat-users.xml":
      ensure  => 'absent',
      require => File["${catalina_base}/conf"],
      notify  => Tomcat::Instance::Service[$instancename],
    }
  }

  file { "${catalina_base}/bin/startup.sh":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File["${catalina_base}/bin"],
    content => template("${module_name}/multi/startup.erb"),
    notify  => Tomcat::Instance::Service[$instancename],
  }

  file { "${catalina_base}/bin/configtest.sh":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File["${catalina_base}/bin"],
    content => template("${module_name}/multi/configtest.erb"),
  }

  file { "${catalina_base}/bin/shutdown.sh":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0755',
    require => File["${catalina_base}/bin"],
    content => template("${module_name}/multi/shutdown.erb"),
    notify  => Tomcat::Instance::Service[$instancename],
  }

  concat { "${catalina_base}/bin/setenv.sh":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0644',
    require => File["${catalina_base}/bin"],
    notify  => Tomcat::Instance::Service[$instancename],
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

  concat::fragment{ "${catalina_base}/bin/setenv.sh GC":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '10',
    content => template("${module_name}/multi/setenv_gc.erb"),
  }

  concat::fragment{ "${catalina_base}/bin/setenv.sh locale":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '11',
    content => template("${module_name}/multi/setenv_locale.erb"),
  }

  if($server_info!=undef) or ($server_number!=undef) or ($server_built!=undef)
  {
    file { "${catalina_base}/lib/org/apache/catalina/util/ServerInfo.properties":
      ensure  => 'present',
      owner   => $tomcat_user,
      group   => $tomcat_user,
      mode    => '0644',
      require => File[$catalina_base],
      notify  => Tomcat::Instance::Service[$instancename],
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
                        "${catalina_base}/lib",
                        "${catalina_base}/logs",
                        "${catalina_base}/temp",
                        "${catalina_base}/bin",
                        "${catalina_base}/conf",
                        "${catalina_base}/conf/sites",
                        "${catalina_base}/webapps",
                        "${catalina_base}/bin/startup.sh",
                        "${catalina_base}/bin/shutdown.sh",
                        "${catalina_base}/bin/configtest.sh",
                      ] ],
                  Concat[ [ "${catalina_base}/bin/setenv.sh",
                            "${catalina_base}/conf/server.xml" ] ] ],
    content => template("${module_name}/multi/tomcat-init.erb"),
    notify  => Tomcat::Instance::Service[$instancename],
  }

  tomcat::instance::service { $instancename:
    manage_service        => $manage_service,
    manage_docker_service => $manage_docker_service,
    service_ensure        => $ensure,
    service_enable        => $enable,
    pid_file              => $pid_file,
  }

  if($catalina_rotate!=undef)
  {
    if(defined(Class['::logrotate']))
    {
      logrotate::logs { "${instancename}.catalina.out":
        ensure       => $catalina_logrotate_ensure,
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
      require => [File["${catalina_base}/webapps"],
                  Exec["untar tomcat tomcat ${tomcat::catalina_home}"],
                  Class['tomcat']],
      before  => Tomcat::Instance::Service[$instancename],
    }

    exec { "cp tomcat host-manager from tomcat-home ${instancename}":
      command => "cp -pr ${tomcat::catalina_home}/webapps/host-manager ${catalina_base}/webapps",
      creates => "${catalina_base}/webapps/host-manager",
      require => [File["${catalina_base}/webapps"],
                  Exec["untar tomcat tomcat ${tomcat::catalina_home}"],
                  Class['tomcat']],
      before  => Tomcat::Instance::Service[$instancename],
    }
  }

  if(!$custom_webxml)
  {
    exec { "cp web.xml from tomcat-home ${instancename}":
      command => "cp -pr ${tomcat::catalina_home}/conf/web.xml ${catalina_base}/conf",
      creates => "${catalina_base}/conf/web.xml",
      require => [File["${catalina_base}/conf"],
                  Exec["untar tomcat tomcat ${tomcat::catalina_home}"],
                  Class['tomcat'] ],
      before  => Tomcat::Instance::Service[$instancename],
    }
  }

  # $error_report_valve_show_report        = undef,
  # $error_report_valve_show_server_info   = undef,

  if($add_error_report_valve_settings)
  {

    tomcat::valve { $instancename:
      classname     => $error_report_valve_class,
      servicename   => $instancename,
      catalina_base => $catalina_base,
      options       => {
                          'showReport'     => $error_report_valve_show_report,
                          'showServerInfo' => $error_report_valve_show_server_info,
                        },
    }

  }



}
