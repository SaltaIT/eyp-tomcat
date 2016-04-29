define tomcat::datasource::postgres (
                                      $catalina_base    = "/opt/${name}",
                                      $servicename      = $name,
                                      $jdbc_version     = '4',
                                      $postgres_version = '9.2',
                                      $srcdir           = '/usr/local/src',
                                      $ensure           = 'present',
                                    ) {
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }
  #https://jdbc.postgresql.org/download/postgresql-9.2-1004.jdbc4.jar

  $url_list = { '4' => { '9.2' => 'https://jdbc.postgresql.org/download/postgresql-9.2-1004.jdbc4.jar'} }

  exec { "wget jdbc ${jdbc_version} postgres ${postgres_version} datasource ${srcdir} ${catalina_base}":
    command => "wget ${url_list[$jdbc_version][$postgres_version]} -O ${srcdir}/postgresql-${postgres_version}.jdbc${jdbc_version}.jar",
    creates => "${srcdir}/postgresql-${postgres_version}.jdbc${jdbc_version}.jar",
  }

  file { "${srcdir}/postgresql-${postgres_version}.jdbc${jdbc_version}.jar":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    require => Exec["wget jdbc ${jdbc_version} postgres ${postgres_version} datasource ${srcdir} ${catalina_base}"],
  }

  tomcat::lib { "jdbc ${jdbc_version} postgres ${postgres_version} datasource ${srcdir} ${catalina_base}":
    ensure        => $ensure,
    jar_name      => "postgresql-${postgres_version}.jdbc${jdbc_version}.jar",
    source        => undef,
    file_ln       => "${srcdir}/postgresql-${postgres_version}.jdbc${jdbc_version}.jar",
    catalina_base => $catalina_base,
    servicename   => $servicename,
    purge_old     => false,
    require       => [
                        Exec["wget jdbc ${jdbc_version} postgres ${postgres_version} datasource ${srcdir} ${catalina_base}"],
                        File["${srcdir}/postgresql-${postgres_version}.jdbc${jdbc_version}.jar"]
                      ],
  }

}
