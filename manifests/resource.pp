define tomcat::resource (
                          $resource_type,
                          $resource_name,
                          $servicename                     = $name,
                          $catalina_base                   = "/opt/${name}",
                          $factory                         = undef,
                          $driver_class_name               = undef,
                          $resource_url                    = undef,
                          $username                        = undef,
                          $password                        = undef,
                          $initial_size                    = undef,
                          $max_active                      = undef,
                          $max_idle                        = undef,
                          $min_idle                        = undef,
                          $validation_query                = undef,
                          $min_evictable_idletimemillis    = undef,
                          $time_between_evictionrunsmillis = undef,
                          $numtests_per_evictionrun        = undef,
                          $init_sql                        = undef,
                          $auth                            = undef,
                          $location                        = undef,
                        ) {
  #
  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  if(!defined(Concat::Fragment["${catalina_base}/conf/server.xml globalnamingresources ini"]))
  {
    concat::fragment{ "${catalina_base}/conf/server.xml globalnamingresources ini":
      target  => "${catalina_base}/conf/server.xml",
      order   => '10',
      content => template("${module_name}/serverxml/10_global_naming_resources_init.erb"),
    }
  }

  concat::fragment{ "${catalina_base}/conf/server.xml resource ${resource_type} ${resource_name}":
    target  => "${catalina_base}/conf/server.xml",
    order   => '11',
    content => template("${module_name}/serverxml/11_resource.erb"),
  }

  if(!defined(Concat::Fragment["${catalina_base}/conf/server.xml globalnamingresources end"]))
  {
    concat::fragment{ "${catalina_base}/conf/server.xml globalnamingresources end":
      target  => "${catalina_base}/conf/server.xml",
      order   => '12',
      content => template("${module_name}/serverxml/12_global_naming_resources_fi.erb"),
    }
  }

}
