#
# -Djava.util.logging.config.file
#
# ISO  date:
# java.util.logging.SimpleFormatter.format = %1$tF %1$tT %2$s%n%4$s: %5$s%6$s%n
#
#
define tomcat::loggingproperties(
                                  $source                 = undef,
                                  $catalina_base          = "/opt/${name}",
                                  $servicename            = $name,
                                  $simpleformatter_format = '%1$tF %1$tT %2$s%n%4$s: %5$s%6$s%n',
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

  if($source!=undef)
  {
    file { "${catalina_base}/conf/logging.properties":
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
    file { "${catalina_base}/conf/logging.properties":
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
