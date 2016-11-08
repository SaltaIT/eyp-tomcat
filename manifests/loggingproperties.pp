#
# -Djava.util.logging.config.file
#
# ISO  date:
# java.util.logging.SimpleFormatter.format = %1$tF %1$tT %2$s%n%4$s: %5$s%6$s%n
#
#
define tomcat::loggingproperties(
                                  $source                  = undef,
                                  $catalina_base           = "/opt/${name}",
                                  $logging_properties_file = "/opt/${name}/conf/logging.properties",
                                  $servicename             = $name,
                                  $simpleformatter_format  = '%1$tF %1$tT %2$s%n%4$s: %5$s%6$s%n',
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

  #java.util.logging.config.file
  tomcat::jvmproperty { "${catalina_base} java.util.logging.config.file":
    property      => 'java.util.logging.config.file',
    value         => $logging_properties_file,
    servicename   => $serviceinstance,
    catalina_base => $catalina_base,
    require       => File[$logging_properties_file],
  }

  if($source!=undef)
  {
    file { $logging_properties_file:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File["${catalina_base}/conf"],
      notify  => $serviceinstance,
      source  => $source,
    }
  }
  else
  {
    file { $logging_properties_file:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File["${catalina_base}/conf"],
      notify  => $serviceinstance,
      content => template("${module_name}/properties/logging.properties.erb"),
    }
  }
}
