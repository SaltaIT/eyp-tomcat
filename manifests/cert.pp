define tomcat::cert (
                      $cert_source   = undef,
                      $cert_file     = undef,
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

  if($cert_source==undef and $cert_file==undef)
  {
    fail('both cert_source and cert_file are undefined')
  }

  if($cert_source!=undef)
  {
    validate_string($cert_source)
  }

  if($cert_file!=undef)
  {
    validate_absolute_path($cert_file)
  }

  if($cert_source!=undef)
  {
    file { "${catalina_base}/conf/keystore_${certname}_${version}.cert":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File["${catalina_base}/conf"],
      source  => $cert_source,
      notify  => $serviceinstance,
    }
  }
  else
  {
    file { "${catalina_base}/conf/keystore_${certname}_${version}.cert":
      ensure  => 'link',
      target  => $cert_file,
      require => File["${catalina_base}/conf"],
      notify  => $serviceinstance,
    }
  }

}
