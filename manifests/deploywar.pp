define tomcat::deploywar (
                            $warname,
                            $source,
                            $catalina_base = "/opt/${name}",
                            $servicename   = $name,
                            $app_base      = 'webapps',
                            $add_root_ln   = false,
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

  file { "${catalina_base}/${app_base}/${warname}.war":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/${app_base}"],
    notify  => $serviceinstance,
    source  => $source,
  }

  if($add_root_ln)
  {
    file { "${catalina_base}/${app_base}/ROOT.war":
      ensure  => 'link',
      target  => "${catalina_base}/${app_base}/${warname}.war",
      require => File["${catalina_base}/${app_base}/${warname}.war"],
      notify  => $serviceinstance,
    }
  }
}
