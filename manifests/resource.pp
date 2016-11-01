# == ORACLE JDBC ==
#
# The relevant documentation for this is quite heavy going, but these are key documents
#
#  http://tomcat.apache.org/tomcat-6.0-doc/jndi-datasource-examples-howto.html
#  http://docs.oracle.com/cd/B28359_01/java.111/b31224/concache.htm
#  https://forums.oracle.com/forums/thread.jspa?threadID=967849
#
# To set debug logging see following URL and edit logging.properties
#
#  http://dev-answers.blogspot.com/2010/03/enable-debugtrace-level-logging-for.html
#
# To reference include files from server.xml see
#
#  http://blogs.mulesoft.org/including-files-into-tomcats-server-xml-using-xml-entity-includes/
#
# Note this subtle but crucial difference for SID vs SERVICE_NAME based connections.
#
#  Old form: jdbc:oracle:thin:<host>:<port>:<SID>
#  New form: jdbc:oracle:thin:@<host>:<port>/<SERVICE_NAME>
#
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
                          $max_wait                        = undef,
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
