define tomcat::jvmproperty(
                            $property,
                            $value,
                            $servicename   = $name,
                            $catalina_base = "/opt/${name}",
                          ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  #validate_array($ldapservers)
  validate_string($ldapbase)

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }

  concat::fragment{ "${catalina_base}/bin/setenv.sh base":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '55',
    content => template("${module_name}/conf/jvm/jvm_properties.erb"),
  }

}
