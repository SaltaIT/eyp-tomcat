# puppet2sitepp @tomcatwebxml
define tomcat::webxml (
                            $source,
                            $catalina_base = "/opt/${name}",
                            $servicename   = $name,
                            $file_owner    = 'tomcat',
                            $file_group    = 'tomcat',
                            $file_mode     = '0644',
                          ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($servicename!=undef)
  {
    $serviceinstance=Tomcat::Instance::Service[$servicename]
  }
  else
  {
    $serviceinstance=undef
  }

  file { "${catalina_base}/conf/web.xml":
    ensure  => 'present',
    owner   => $file_owner,
    group   => $file_group,
    mode    => $file_mode,
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    source  => $source,
  }

}
