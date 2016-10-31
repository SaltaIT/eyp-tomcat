define tomcat::alias(
                        $url,
                        $servicename           = $name,
                        $catalina_base         = "/opt/${name}",
                      ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  concat::fragment{ "${catalina_base}/conf/server.xml alias ${name} ${catalina_base} ${servicename} ${url}":
    target  => "${catalina_base}/conf/server.xml",
    order   => '26',
    content => "<Alias>${url}</Alias>\n",
  }

}
