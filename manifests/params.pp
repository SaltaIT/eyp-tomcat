class tomcat::params() {

  $default_tomcat_user='tomcat'
  # $default_webapps_mode=


  case $::osfamily
  {
    'redhat':
    {
      $develpkg=[ 'apr-devel' ]

      case $::operatingsystemrelease
      {
        /^[5-6].*$/:
        {
          $systemd=false
        }
        /^[7-8].*$/:
        {
          $systemd=true
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      $develpkg=[ 'libapr1-dev', 'libapr1' ]
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $systemd=false
            }
            /^1[68].*$/:
            {
              $systemd=true
            }
            /^20.*$/:
            {
              $systemd=true
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            /^[89].*$/:
            {
              $systemd=true
            }
            /^10.*$/:
            {
              $systemd=true
            }
            default: { fail("Unsupported Debian version! - ${::operatingsystemrelease}")  }
          }
        }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
