define tomcat::instance::service(
                                  $manage_service        = true,
                                  $manage_docker_service = true,
                                  $service_ensure        = 'running',
                                  $service_enable        = true,
                                  $instancename          = $name,
                                  $pid_file              = "/var/run/${name}.pid",
                                ) {
  #
  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $manage_docker_service)
  {
    if($manage_service)
    {
      service { $instancename:
        ensure     => $service_ensure,
        enable     => $service_enable,
        hasrestart => true,
        require    => File["/etc/init.d/${instancename}"],
      }

      if($tomcat::params::systemd)
      {
        include systemd

        systemd::service { $instancename:
          execstart => "/bin/bash /etc/init.d/${instancename} start",
          execstop  => "/bin/bash /etc/init.d/${instancename} stop",
          require   => File["/etc/init.d/${instancename}"],
          before    => Service[$instancename],
          notify    => Service[$instancename],
          forking   => true,
          restart   => 'no',
          pid_file  => $pid_file,
        }
      }
    }
  }
}
