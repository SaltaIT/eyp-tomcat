define tomcat::context(
                        $servicename           = $name,
                        $catalina_base         = "/opt/${name}",
                        $path                  = undef,
                        $docbase               = undef,
                        $reloadable            = undef,
                      ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }


  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  concat::fragment{ "${catalina_base}/conf/server.xml context ${path}":
    target  => "${catalina_base}/conf/server.xml",
    order   => '28',
    content => template("${module_name}/conf/context.erb"),
  }

}
