# puppet2sitepp @tomcatusers
define tomcat::tomcatuser (
                            $tomcatuser,
                            $password,
                            $catalina_base = "/opt/${name}",
                            $servicename   = $name,
                            $pwdigest      = 'sha',
                            $roles         = [ 'tomcat', 'manager', 'admin', 'manager-gui' ],
                          ) {
  validate_re($pwdigest, [ '^sha$', '^plaintext$'], 'Not a supported digest: sha/plaintext')

  if ($pwdigest=='sha')
  {
    $digestedpassword=sha1($password)
  }
  else
  {
    $digestedpassword=$password
  }

  concat::fragment{ "${catalina_base}/conf/tomcat-users.xml user ${tomcatuser}":
    target  => "${catalina_base}/conf/tomcat-users.xml",
    order   => '55',
    content => template("${module_name}/tomcatusers/user.erb"),
  }
}
