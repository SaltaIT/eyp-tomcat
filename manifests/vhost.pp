define tomcat::vhost(
                      $vhostname,
                      $appbase,
                      $unpack_wars   = true,
                      $autodeploy    = true,
                      $servicename   = $name,
                      $catalina_base = "/opt/${name}",
                    ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  # <Host name="localhost"  appBase="webapps"
  #       unpackWARs="true" autoDeploy="true"

}
