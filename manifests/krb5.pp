# https://dzone.com/articles/do-not-publish-configuring-tomcat-single-sign-on-w

# ; for Windows 2003
#
# ;          default_tgs_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
# ;          default_tkt_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
# ;          permitted_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
#
# ; for Windows 2008 with AES
#
# ;        default_tgs_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
# ;        default_tkt_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
# ;        permitted_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
#
# ; for MIT/Heimdal kdc no need to restrict encryption type

define tomcat::krb5 (
                            $realm,
                            $kdc,
                            $keytab_source,
                            $use_subject_creds_only = false,
                            $default_keytab         = undef,
                            $servicename            = $name,
                            $catalina_base          = "/opt/${name}",
                            $enctypes               = [ 'aes256-cts', 'aes128-cts', 'rc4-hmac', 'des3-cbc-sha1', 'des-cbc-crc' ],

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
  tomcat::jvmproperty { "${catalina_base} javax.security.auth.useSubjectCredsOnly":
    property      => 'javax.security.auth.useSubjectCredsOnly',
    value         => $use_subject_creds_only,
    servicename   => $servicename,
    catalina_base => $catalina_base,
    require       => File["${catalina_base}/conf/krb5.ini"],
  }

  # redundat, just to be on the safe side
  tomcat::jvmproperty { "${catalina_base} java.security.krb5.conf":
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
