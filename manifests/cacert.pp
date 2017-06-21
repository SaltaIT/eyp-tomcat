define tomcat::cacert (
                        $ca_source     = undef,
                        $ca_file       = undef,
                        $certname      = $name,
                        $version       = '',
                        $servicename   = $name,
                        $catalina_base = "/opt/${name}",
                      ) {
  if($servicename!=undef)
  {
    $serviceinstance=Tomcat::Instance::Service[$servicename]
  }
  else
  {
    $serviceinstance=undef
  }

  if($ca_source==undef and $ca_file==undef)
  {
    fail('both ca_source and ca_file are undefined')
  }

  if($ca_source!=undef)
  {
    validate_string($ca_source)
  }

  if($ca_file!=undef)
  {
    validate_absolute_path($ca_file)
  }

  if($ca_source!=undef)
  {
    file { "${catalina_base}/conf/thuststore_${certname}_${version}.cert":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => $ca_source,
      require => File["${catalina_base}/conf"],
      notify  => $serviceinstance,
    }
  }
  else
  {
    file { "${catalina_base}/conf/thuststore_${certname}_${version}.cert":
      ensure => 'link',
      target => $ca_file,
      require => File["${catalina_base}/conf"],
      notify  => $serviceinstance,
    }
  }
}
