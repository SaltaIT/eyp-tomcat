# ======================================================================================
#
# The relevant documentation:
#
#   http://tomcat.apache.org/tomcat-7.0-doc/config/realm.html
#   http://tomcat.apache.org/tomcat-7.0-doc/realm-howto.html
#
# The following URL's also contain useful information.
#
#   http://stackoverflow.com/questions/267869/configuring-tomcat-to-authenticate-using-windows-active-directory
#   http://www.coderanch.com/t/421370/Tomcat/Tomcat-Active-Directory-Windows-Server
#    http://stackoverflow.com/questions/1443189/how-to-set-up-tomcat-ldap-authentication-without-member-of-check
#
# ======================================================================================
#
# The directory realm supports two approaches to the representation of roles in the directory:
#
#  1) Roles as explicit directory entries
#
#  Roles may be represented by explicit directory entries. A role entry is usually an LDAP group
#  entry with one attribute containing the name of the role and another whose values are the
#  distinguished names or usernames of the users in that role. The following attributes configure
#  a directory search to find the names of roles associated with the authenticated user:
#
#  roleBase -  the base entry for the role search. If not specified, the search base is the
#      top-level directory context.
#  roleSubtree -  the search scope. Set to true if you wish to search the entire subtree rooted
#      at the roleBase entry. The default value of false requests a single-level
#      search including the top level only.
#  roleSearch -  the LDAP search filter for selecting role entries. It optionally includes
#      pattern replacements "{0}" for the distinguished name and/or "{1}" for the
#      username of the authenticated user.
#  roleName -  the attribute in a role entry containing the name of that role
#
#  2) Roles as an attribute of the user entry
#
#  Role names may also be held as the values of an attribute in the user's directory entry.
#  Use userRoleName to specify the name of this attribute.
#
#  A combination of both approaches to role representation may be used.
#
# ======================================================================================
#
# Debug logging
#
#   http://dev-answers.blogspot.com/2010/03/enable-debugtrace-level-logging-for.html
#
# Include files from server.xml
#
#   http://blogs.mulesoft.org/including-files-into-tomcats-server-xml-using-xml-entity-includes/
#
# ** There is no way built in to tomcat to obfuscate the password on a JNDI resource **
#
# ======================================================================================
define tomcat::realm::jndi(
                            #required options
                            $connection_url,
                            $connection_name,
                            $connection_password,
                            $user_base,
                            $role_base,
                            #instance options
                            $catalina_base  = "/opt/${name}",
                            $servicename    = $name,
                            $order          = '1',
                            #options
                            $role_search = '(member={0})',
                            $role_name = 'cn',
                            $user_search = '(sAMAccountName={0})',
                            $alternate_url  = undef,
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
