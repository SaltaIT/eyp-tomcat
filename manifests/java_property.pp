#
# -Dproperty=value: Sets a system property value. The property variable is a
# string with no spaces that represents the name of the property. The value
# variable is a string that represents the value of the property.
#
# puppet2sitepp @tomcatjavaproperties
define tomcat::java_property(
                              $property,
                              $value,
                              $catalina_base = "/opt/${name}",
                              $servicename   = $name,
                            ) {
  #
  if(!defined(Concat::Fragment["${catalina_base}/bin/setenv.sh custom java properties header"]))
  {
    concat::fragment{ "${catalina_base}/bin/setenv.sh custom java properties header":
      target  => "${catalina_base}/bin/setenv.sh",
      order   => '13a',
      content => "\n#\n# custom java properties\n#\n",
    }
  }

  concat::fragment{ "${catalina_base}/bin/setenv.sh java custom property ${property}=${value}":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '13b',
    content => template("${module_name}/multi/custom_java_property.erb")
  }
}
