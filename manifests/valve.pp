# puppet2sitepp @tomcatvalves
define tomcat::valve(
                        $classname,
                        $options       = undef,
                        $servicename   = $name,
                        $catalina_base = "/opt/${name}",
                      ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($options!=undef)
  {
    validate_hash($options)
  }

  concat::fragment{ "${catalina_base}/conf/server.xml valve ${name} ${catalina_base} ${servicename} ${classname}":
    target  => "${catalina_base}/conf/server.xml",
    order   => '26',
    content => template("${module_name}/conf/valve.erb"),
  }

}
