define tomcat::krb5::keytab (
                              $source        = undef,
                              $catalina_base = "/opt/${name}",
                              $servicename   = $name,
                              $ensure        = 'present',
                            ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }


  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }
  else
  {
    $serviceinstance=undef
  }

  file { "${catalina_base}/conf/krb5.keytab":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    source  => $source,
  }
}
