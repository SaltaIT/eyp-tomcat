#<ResourceLink
# name="jdbc/ARL"
# global="jdbc/ARL"
# type="oracle.jdbc.pool.OracleDataSource" />
define tomcat::contextxml::resourcelink(
                                        $resname,
                                        $global,
                                        $type,
                                        $servicename   = $name,
                                        $catalina_base = "/opt/${name}",
                                      ) {
  concat::fragment{ "${catalina_base}/conf/context.xml resourcelink ${resname}":
    target  => "${catalina_base}/conf/context.xml",
    order   => '10',
    content => template("${module_name}/conf/contextxml/resourcelink.erb"),
  }
}
