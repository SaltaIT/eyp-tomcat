define tomcat::tomcatrole (
                            $rolename    = $name,
                            $description = undef,
                          ) {
  concat::fragment{ "${catalina_base}/conf/tomcat-users.xml role ${rolename}":
    target  => "${catalina_base}/conf/tomcat-users.xml",
    order   => '44',
    content => template("${module_name}/tomcatusers/role.erb"),
  }
}
