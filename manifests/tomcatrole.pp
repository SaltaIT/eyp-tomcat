define tomcat::tomcatrole (
                            $rolename,
                            $description = undef,
                            $catalina_base = "/opt/${name}",
                            $servicename   = $name,
                          ) {
  concat::fragment{ "${catalina_base}/conf/tomcat-users.xml role ${rolename}":
    target  => "${catalina_base}/conf/tomcat-users.xml",
    order   => '44',
    content => template("${module_name}/tomcatusers/role.erb"),
  }
}
