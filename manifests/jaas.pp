#
#    88                       88
#    ""                       88
#                             88
#    88 ,adPPYYba,  ,adPPYba, 88   ,d8  ,adPPYYba, ,adPPYba, ,adPPYba,
#    88 ""     `Y8 a8"     "" 88 ,a8"   ""     `Y8 I8[    "" I8[    ""
#    88 ,adPPPPP88 8b         8888[     ,adPPPPP88  `"Y8ba,   `"Y8ba,
#    88 88,    ,88 "8a,   ,aa 88`"Yba,  88,    ,88 aa    ]8I aa    ]8I
#    88 `"8bbdP"Y8  `"Ybbd8"' 88   `Y8a `"8bbdP"Y8 `"YbbdP"' `"YbbdP"'
#   ,88
# 888P"
#
define tomcat::jaas (
                            #LDAP zookeeper
                            $app                 = undef,
                            $provider            = undef,
                            $filter              = undef,
                            $username            = 'tomcat',
                            $password            = 'tomcat',
                            #KRB5
                            $realm               = undef,
                            $spn                 = undef,
                            $debug               = false,
                            $is_initiator        = true,
                            $refresh_krb5_config = true,
                            $module_banner       = true,
                            $store_pass          = true,
                            #altres
                            $servicename         = $name,
                            $catalina_base       = "/opt/${name}",
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

  if($debug)
  {
    #TODO: identificar LDAP vs kerberos
    #-Dsun.security.krb5.debug=true
    tomcat::jvmproperty { 'sun.security.krb5.debug':
      value         => $debug,
      servicename   => $servicename,
      catalina_base => $catalina_base,
    }
  }

  file { "${catalina_base}/conf/jaas.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${catalina_base}/conf"],
    notify  => $serviceinstance,
    content => template("${module_name}/conf/jaas.erb"),
  }

  #java.security.auth.login.config
  tomcat::jvmproperty { 'java.security.auth.login.config':
    value         => "${catalina_base}/conf/jaas.conf",
    servicename   => $servicename,
    catalina_base => $catalina_base,
    require       => File["${catalina_base}/conf/jaas.conf"],
  }

  # concat::fragment{ "${catalina_base}/bin/setenv.sh jaas":
  #   target  => "${catalina_base}/bin/setenv.sh",
  #   order   => '00',
  #   content => template("${module_name}/multi/setenv_jaas.erb"),
  # }
}
