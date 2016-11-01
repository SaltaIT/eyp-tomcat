class tomcat::params() {

  $default_tomcat_user='tomcat'
  $default_webapps_mode='0775'


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
        /^7.*$/:
        {
          $systemd=true
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $systemd=false
              $develpkg=[ 'libapr1-dev', 'libapr1' ]
            }
            /^16.*$/:
            {
              $systemd=true
              $develpkg=[ 'libapr1-dev', 'libapr1' ]
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            '8':
            {
              $systemd=true
              $develpkg=[ 'libapr1-dev', 'libapr1' ]
            }
        }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
