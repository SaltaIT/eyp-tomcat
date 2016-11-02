# https://dzone.com/articles/do-not-publish-configuring-tomcat-single-sign-on-w
define tomcat::krb5 (
                            $realm,
                            $kdc,
                            $keytab_source,
                            $forwardable            = true,
                            $use_subject_creds_only = false,
                            $default_keytab         = undef,
                            $servicename            = $name,
                            $catalina_base          = "/opt/${name}",
                          ) {
  #
  validate_array($kdc)

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }
  else
  {
    $serviceinstance=undef
  }

  #javax.security.auth.useSubjectCredsOnly=false
  tomcat::jvmproperty { 'javax.security.auth.useSubjectCredsOnly':
    property      => 'javax.security.auth.useSubjectCredsOnly',
    value         => $use_subject_creds_only,
    servicename   => $servicename,
    catalina_base => $catalina_base,
    require       => File["${catalina_base}/conf/krb5.ini"],
  }

  # redundat, just to be on the safe side
  tomcat::jvmproperty { 'java.security.krb5.conf':
    property      => 'java.security.krb5.conf',
    value         => "${catalina_base}/conf/krb5.ini",
    servicename   => $servicename,
    catalina_base => $catalina_base,
    require       => File["${catalina_base}/conf/krb5.ini"],
  }

  file { "${catalina_base}/conf/krb5.ini":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    content => template("${module_name}/conf/krb5.erb"),
  }

  file { "${catalina_base}/conf/krb5.keytab":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    source  => $keytab_source,
  }
}
