# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class tomcat(
              $tomcat_src         = undef,
              $tomcat_url         = undef,
              $manage_tomcat_user = true,
              $tomcat_user        = 'tomcat',
              $tomcat_user_home   = '/home/tomcat',
              $tomcat_user_shell  = '/bin/bash',
              $tomcat_user_uid    = undef,
              $catalina_home      = '/opt/tomcat-home',
              $srcdir             = '/usr/local/src',
              $nativelibrary      = true,
            ) inherits tomcat::params {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  validate_absolute_path($srcdir)

  if($manage_tomcat_user)
  {
    group { $tomcat_user:
      ensure => present,
      gid    => $tomcat_user_uid,
    }

    user { $tomcat_user:
      ensure     => present,
      shell      => $tomcat_user_shell,
      uid        => $tomcat_user_uid,
      gid        => $tomcat_user,
      managehome => true,
      home       => $tomcat_user_home,
      require    => Group[$tomcat_user],
      before     => File[$catalina_home],
    }
  }

  exec { "mkdir p tomcat multi ${srcdir}":
    command => "mkdir -p ${srcdir}",
    creates => $srcdir,
  }

  if($tomcat_src!=undef)
  {
    file { "${srcdir}/tomcat.tgz":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      source  => $tomcat_src,
      notify  => Exec["untar tomcat ${name} ${catalina_home}"],
      require => Exec["mkdir p tomcat multi ${srcdir}"],
    }
  }
  else
  {
    if($tomcat_url!=undef)
    {
      exec { "wget tomcat ${srcdir}":
        command => "wget ${tomcat_url} -O ${srcdir}/tomcat.tgz",
        creates => "${srcdir}/tomcat.tgz",
        notify  => Exec["untar tomcat ${name} ${catalina_home}"],
        require => Exec["mkdir p tomcat multi ${srcdir}"],
      }

      file { "${srcdir}/tomcat.tgz":
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        require => Exec["mkdir p tomcat multi ${srcdir}", "wget tomcat ${srcdir}"],
      }

    }
    else
    {
      fail('tomcat tarball undefined: please, define either tomcat_src or tomcat_url')
    }
  }


  file { $catalina_home:
    ensure => 'directory',
    owner  => $tomcat_user,
    group  => $tomcat_user,
    mode   => '0755',
  }

  exec { "untar tomcat ${name} ${catalina_home}":
    command => "tar xzf ${srcdir}/tomcat.tgz -C ${catalina_home} --strip 1",
    creates => "${catalina_home}/bin/catalina.sh",
    require => File[ [$catalina_home, "${srcdir}/tomcat.tgz" ] ],
    notify  => Exec["chown ${tomcat_user} ${name} ${catalina_home}"],
  }

  exec { "chown ${tomcat_user} ${name} ${catalina_home}":
    command     => "chown -R ${tomcat_user}. ${catalina_home}",
    refreshonly => true,
    require     => Exec["untar tomcat ${name} ${catalina_home}"],
  }

  if($nativelibrary)
  {
    package { $tomcat::params::develpkg:
      ensure => 'installed',
    }

    file { "${srcdir}/tomcat-native-library":
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Exec["mkdir p tomcat multi ${srcdir}"],
    }

    exec { "tar xzf native library ${srcdir}":
      command => "tar xzf ${catalina_home}/bin/tomcat-native.tar.gz -C ${srcdir}/tomcat-native-library --strip-components=1",
      require => [ Exec["untar tomcat ${name} ${catalina_home}"], File["${srcdir}/tomcat-native-library"] ],
      creates => "${srcdir}/tomcat-native-library/LICENSE",
    }

    exec { "configure native library ${srcdir}":
      command => 'bash -c "./configure --with-apr=/usr/bin/apr-1-config --with-java-home=$(dirname $(jrunscript -e \'java.lang.System.out.println(java.lang.System.getProperty("java.home"));\'))"',
      require => [ Package[$tomcat::params::develpkg], Exec["tar xzf native library ${srcdir}"] ],
      cwd     => "${srcdir}/tomcat-native-library/jni/native",
      creates => "${srcdir}/tomcat-native-library/jni/native/Makefile",
    }

    exec { "make install native library ${srcdir}":
      command => 'make all install',
      require => Exec["configure native library ${srcdir}"],
      cwd     => "${srcdir}/tomcat-native-library/jni/native",
      creates => '/usr/local/apr/lib/libtcnative-1.so',
    }

    file { '/etc/ld.so.conf.d/tomcat-native-library.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "/usr/local/apr/lib/\n",
      notify  => Exec['tomcat library ldconfig'],
      require => Exec["make install native library ${srcdir}"],
    }

    exec { 'tomcat library ldconfig':
      command     => 'ldconfig',
      refreshonly => true,
    }
  }

}
