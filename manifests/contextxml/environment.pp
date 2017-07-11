#<Environment name="portalenv"
# value="APPL-D-LIFE-PRD-"
# type="java.lang.String"
# override="false" />
#
# puppet2sitepp @tomcatcontextxmlenvs
#
define tomcat::contextxml::environment(
                                        $envname,
                                        $value,
                                        $type,
                                        $override      = false,
                                        $servicename   = $name,
                                        $catalina_base = "/opt/${name}",
                                      ) {
  concat::fragment{ "${catalina_base}/conf/context.xml environment ${envname} ${value} ${type} ${servicename} ${catalina_base}":
    target  => "${catalina_base}/conf/context.xml",
    order   => '10',
    content => template("${module_name}/conf/contextxml/environment.erb"),
  }
}
