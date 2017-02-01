define tomcat::vhost(
                      $vhostname,
                      $appbase,
                      $unpack_wars   = true,
                      $autodeploy    = true,
                      $servicename   = $name,
                      $catalina_base = "/opt/${name}",
                      $tomcat_user   = $tomcat::params::default_tomcat_user,
                    ) {

  fail('TODO: not implamented')

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

  # <Host name="localhost"  appBase="webapps"
  #       unpackWARs="true" autoDeploy="true"

  fail('work in progress, do NOT use tomcat::vhost')

  concat { "${catalina_base}/conf/sites/${vhostname}.xml":
    ensure  => 'present',
    owner   => $tomcat_user,
    group   => $tomcat_user,
    mode    => '0644',
    require => File["${catalina_base}/conf/sites"],
    notify  => $serviceinstance,
  }

  concat::fragment{ "${catalina_base}/conf/sites/${vhostname}.xml end host":
    target  => "${catalina_base}/conf/sites/${vhostname}.xml",
    order   => '00',
    content => template("${module_name}/serverxml/vhost/00_host.erb"),
  }

  concat::fragment{ "${catalina_base}/conf/sites/${vhostname}.xml end host":
    target  => "${catalina_base}/conf/sites/${vhostname}.xml",
    order   => '99',
    content => "        </Host>\n",
  }

}
