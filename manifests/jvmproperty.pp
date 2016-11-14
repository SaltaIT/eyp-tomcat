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

  concat::fragment{ "${catalina_base} setenv.sh JVM property ${property} ${value}":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '55',
    content => template("${module_name}/conf/jvm/jvm_properties.erb"),
  }

}
