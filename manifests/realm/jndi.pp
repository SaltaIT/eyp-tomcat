define tomcat::realm::jndi(
                            #required options
                            $connection_url,
                            $connection_name,
                            $user_base,
                            $user_search,
                            $role_base,
                            $role_name,
                            $role_search,
                            #instance options
                            $catalina_base  = "/opt/${name}",
                            $servicename    = $name,
                            $order          = '1',
                            #options
                            $alternate_url  = undef,
                            $connection_password,
                            $referrals      = 'follow',
                            $user_subtree   = true,
                            $role_subtree   = true,
                            $role_nested    = true,
                            $user_role_name = 'memberOf',
                          ) {
  #
  concat::fragment{ "${catalina_base}/conf/server.xml realm jdni":
    target  => "${catalina_base}/conf/server.xml",
    order   => "23${order}",
    content => template("${module_name}/conf/realms/jndi.erb"),
  }
}
