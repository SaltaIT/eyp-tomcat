define tomcat::include::resource(
                                  $resourcename,
                                  $servicename   = $name,
                                  $catalina_base = "/opt/${name}",
                                ) {
#   <!DOCTYPE server-xml [
#   <!ENTITY AdminRe-DSO SYSTEM "AdminRe-DSO.xml">
#   <!ENTITY AdminRe-JDBC SYSTEM "AdminRe-JDBC.xml">
#   <!ENTITY AdminRe-JNDI SYSTEM "AdminRe-JNDI.xml">
#   <!ENTITY AdminRe-ROOT SYSTEM "AdminRe-ROOT.xml">
# ]>

concat::fragment{ "${catalina_base}/conf/server.xml service":
  target  => "${catalina_base}/conf/server.xml",
  order   => '20',
  content => template("${module_name}/serverxml/20_service.erb"),
}

}
