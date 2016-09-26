define tomcat::agent (
                        $jar_name,
                        $source        = undef,
                        $file_ln       = undef,
                        $catalina_base = "/opt/${name}",
                        $servicename   = $name,
                        $purge_old     = true,
                        $ensure        = 'present',
                      ) {

  if ! defined(Class['tomcat'])
  {
    fail('You must include the tomcat base class before using any tomcat defined resources')
  }

  if($source==undef and $file_ln==undef)
  {
    fail('You have to specify source or file_ln')
  }

  if($source!=undef and $file_ln!=undef)
  {
    fail('You cannotspecify both source and file_ln')
  }

  if($file_ln!=undef)
  {
    validate_absolute_path($file_ln)
  }

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($servicename!=undef)
  {
    $serviceinstance=Service[$servicename]
  }
  else
  {
    $serviceinstance=undef
  }

  if($purge_old)
  {
    exec{ "purge old ${catalina_base} ${jar_name}":
      command => "ls ${catalina_base}/${name}/*jar | grep -v ${jar_name} | grep -E $(echo ${jar_name}.jar | sed 's/^\\(.*\\)-[0-9.]*\\.jar$/\\1/')'-[0-9.]+.jar' | xargs rm",
      onlyif  => "ls ${catalina_base}/${name}/*jar | grep -v ${jar_name} | grep -E $(echo ${jar_name}.jar | sed 's/^\\(.*\\)-[0-9.]*\\.jar$/\\1/')'-[0-9.]+.jar'",
      notify  => $serviceinstance,
    }
  }

  file { "${catalina_base}/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File[$catalina_base],
  }

  if($source!=undef)
  {
    file { "${catalina_base}/${name}/${jar_name}.jar":
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File["${catalina_base}/${name}"],
      source  => $source,
    }
  }

  if($file_ln!=undef)
  {
    file { "${catalina_base}/${name}/${jar_name}.jar":
      ensure  => 'link',
      target  => $file_ln,
      require => File["${catalina_base}/${name}"],
    }
  }

  concat::fragment{ "${catalina_base}/bin/setenv.sh javaagent ${name} ${jar_name}":
    target  => "${catalina_base}/bin/setenv.sh",
    order   => '10',
    content => template("${module_name}/multi/setenv_javaagent.erb"),
  }
}
