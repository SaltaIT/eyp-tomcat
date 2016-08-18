# tomcat

![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

**NTTCom-MS/eyp-tomcat**: [![Build Status](https://travis-ci.org/NTTCom-MS/eyp-tomcat.png?branch=master)](https://travis-ci.org/NTTCom-MS/eyp-tomcat)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What tomcat affects](#what-tomcat-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tomcat](#beginning-with-tomcat)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
    * [Contributing](#contributing)

## Overview

Multi instance tomcat installation

## Module Description

Multi instance tomcat installation and configuration of:
 * server.xml
   * context, connectors, reals, values...
 * JVM memory settings
 * context.xml
 * authenticators
 * jaas
 * jndi
 * custom library deployment (tar.gz)
 * web.xml
 * custom properties files
 * postgres jdbc driver

## Setup

### What tomcat affects

By default,
 * **CATALINA_HOME**: /opt/tomcat-home (configured on class **tomcat**)
 * **CATALINA_BASE**: "/opt/${name}" (configured on define **instance**)

### Setup Requirements

This module requires pluginsync enabled and **eyp/nsswitch** module installed, optionally **eyp-java**

If **eyp-logrotate** is available, it can define catalina.out file rotation

### Beginning with tomcat

simple example:

```puppet
class { 'tomcat':
  tomcat_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
  nativelibrary => true,
}

tomcat::instance { 'tomcat-8080':
  tomcatpw => 'lol',
  shutdown_port=>'2022',
  ajp_port=>'8081',
  connector_port=>'8080',
  jmx_port => '2021',
  lockoutrealm => false,
}

tomcat::instance { 'tomcat-8888':
  tomcatpw => 'lol',
  shutdown_port=>'9000',
  ajp_port=>'8885',
  connector_port=>'8888',
  jmx_port => '9999',
  lockoutrealm => true,
}
```

## Usage

#### Multi instance installation example:

```yaml
---
paquets_general:
  - gcc
classes:
  - tomcat
  - java
java::java_package: java-1.8.0-openjdk
java::java_devel_package: java-1.8.0-openjdk-devel
tomcat::tomcat_src: puppet:///tomcat/apache-tomcat-7.0.57.tar.gz
tomcat::nativelibrary: true
tomcatinstances:
  tomcat8080:
    tomcatpw: a12345
    shutdown_port: 8070
    jmx_port: 8060
    ajp_port: ""
    connector_port: 8080
    xmx: 1024m
    xms: 512m
    realms:
      - es.systemadmin.es.sso.tomcat.SSORealm
    values:
      - org.apache.catalina.authenticator.SingleSignOn
    errorReportValveClass: es.systemadmin.es.sso.tomcat.SSOErrorValve
    LockOutRealm: false
    UserDatabase: false
    extra_vars:
      CONNECTOR_PORT:
        8080
    rmi_server_hostname: "%{::ipaddress_eth0}"
  tomcat8081:
    tomcatpw: a12345
    shutdown_port: 8071
    jmx_port: 8061
    ajp_port: ""
    connector_port: 8081
    xmx: 1024m
    xms: 512m
    realms:
      - es.systemadmin.es.sso.tomcat.SSORealm
    values:
      - org.apache.catalina.authenticator.SingleSignOn
    errorReportValveClass: es.systemadmin.es.sso.tomcat.SSOErrorValve
    LockOutRealm: false
    UserDatabase: false
    extra_vars:
      CONNECTOR_PORT:
        8081
    rmi_server_hostname: "%{::ipaddress_eth0}"
  tomcat8082:
    tomcatpw: a12345
    shutdown_port: 8072
    jmx_port: 8062
    ajp_port: ""
    connector_port: 8082
    xmx: 1024m
    xms: 512m
    realms:
      - es.systemadmin.es.sso.tomcat.SSORealm
    values:
      - org.apache.catalina.authenticator.SingleSignOn
    errorReportValveClass: es.systemadmin.es.sso.tomcat.SSOErrorValve
    LockOutRealm: false
    UserDatabase: false
    extra_vars:
      CONNECTOR_PORT:
        8082
    rmi_server_hostname: "%{::ipaddress_eth0}"
  tomcat8083:
    tomcatpw: a12345
    shutdown_port: 8073
    jmx_port: 8063
    ajp_port: ""
    connector_port: 8083
    xmx: 1024m
    xms: 512m
    realms:
      - es.systemadmin.es.sso.tomcat.SSORealm
    values:
      - org.apache.catalina.authenticator.SingleSignOn
    errorReportValveClass: es.systemadmin.es.sso.tomcat.SSOErrorValve
    LockOutRealm: false
    UserDatabase: false
    rmi_server_hostname: "%{::ipaddress_eth0}"
```

#### jaas properties example

```yaml
jaasproperties:
  tomcat8080:
    app: SystemAdminInternalConfig
    provider: ldap://1.2.3.4:389/ou=People,dc=systemadmin,dc=es
    filter: (&(uid={USERNAME})(objectClass=inetOrgPerson))
  tomcat8081:
    app: SystemAdminInternalConfig
    provider: ldap://1.2.3.4:389/ou=People,dc=systemadmin,dc=es
    filter: (&(uid={USERNAME})(objectClass=inetOrgPerson))
  tomcat8082:
    app: SystemAdminInternalConfig
    provider: ldap://1.2.3.4:389/ou=People,dc=systemadmin,dc=es
    filter: (&(uid={USERNAME})(objectClass=inetOrgPerson))
  tomcat8083:
    app: SystemAdminInternalConfig
    provider: ldap://1.2.3.4:389/ou=People,dc=systemadmin,dc=es
    filter: (&(uid={USERNAME})(objectClass=inetOrgPerson))
```

#### jndi properties example

```yaml
jndiproperties:
  tomcat8080:
    ldapservers:
      - "ldap1.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
      - "ldap2.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
    ldapbase: "%{hiera('systemadmin::ldapbase')}"
    ldapadmin: "%{hiera('systemadmin::ldapadmin')}"
    ldapadminpassword: "%{hiera('openldap::server::adminpassword')}"
  tomcat8081:
    ldapservers:
      - "ldap1.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
      - "ldap2.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
    ldapbase: "%{hiera('systemadmin::ldapbase')}"
    ldapadmin: "%{hiera('systemadmin::ldapadmin')}"
    ldapadminpassword: "%{hiera('openldap::server::adminpassword')}"
  tomcat8082:
    ldapservers:
      - "ldap1.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
      - "ldap2.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
    ldapbase: "%{hiera('systemadmin::ldapbase')}"
    ldapadmin: "%{hiera('systemadmin::ldapadmin')}"
    ldapadminpassword: "%{hiera('openldap::server::adminpassword')}"
  tomcat8083:
    ldapservers:
      - "ldap1.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
      - "ldap2.%{::ntteam_ptr_fqdn_tokenized_2}.systemadmin.es"
    ldapbase: "%{hiera('systemadmin::ldapbase')}"
    ldapadmin: "%{hiera('systemadmin::ldapadmin')}"
    ldapadminpassword: "%{hiera('openldap::server::adminpassword')}"
```

#### authenticators example

```yaml
tomcatauthenticators:
  tomcat8080:
    basic: es.systemadmin.sso.tomcat.BasicAuthenticator
    form: es.systemadmin.sso.tomcat.FormAuthenticator
  tomcat8081:
    basic: es.systemadmin.sso.tomcat.BasicAuthenticator
    form: es.systemadmin.sso.tomcat.FormAuthenticator
  tomcat8082:
    basic: es.systemadmin.sso.tomcat.BasicAuthenticator
    form: es.systemadmin.sso.tomcat.FormAuthenticator
  tomcat8083:
    basic: es.systemadmin.sso.tomcat.BasicAuthenticator
    form: es.systemadmin.sso.tomcat.FormAuthenticator
```

####  library tarball installation example

```yaml
tomcatlibstarballs:
  tomcat8080:
    source: puppet:///customers/example/tomcatlibs.tgz
  tomcat8081:
    source: puppet:///customers/example/tomcatlibs.tgz
  tomcat8082:
    source: puppet:///customers/example/tomcatlibs.tgz
  tomcat8083:
    source: puppet:///customers/example/tomcatlibs.tgz
```

#### custom tomcat properties file deployment example

```yaml
tomcatproperties:
  catalina8080:
    properties_file: catalina
    source: puppet:///customers/example/catalina.properties
    catalina_base: /opt/tomcat8080
    servicename: tomcat8080
  catalina8081:
    properties_file: catalina
    source: puppet:///customers/example/catalina.properties
    catalina_base: /opt/tomcat8081
    servicename: tomcat8081
  catalina8082:
    properties_file: catalina
    source: puppet:///customers/example/catalina.properties
    catalina_base: /opt/tomcat8082
    servicename: tomcat8082
  catalina8083:
    properties_file: catalina
    source: puppet:///customers/example/catalina.properties
    catalina_base: /opt/tomcat8083
    servicename: tomcat8083
  logging8080:
    properties_file: logging
    source: puppet:///customers/example/logging.properties
    catalina_base: /opt/tomcat8080
    servicename: tomcat8080
  logging8081:
    properties_file: logging
    source: puppet:///customers/example/logging.properties
    catalina_base: /opt/tomcat8081
    servicename: tomcat8081
  logging8082:
    properties_file: logging
    source: puppet:///customers/example/logging.properties
    catalina_base: /opt/tomcat8082
    servicename: tomcat8082
  logging8083:
    properties_file: logging
    source: puppet:///customers/example/logging.properties
    catalina_base: /opt/tomcat8083
    servicename: tomcat8083
```

#### web.xml example

```yaml
tomcatwebxml:
  tomcat8080:
    source: puppet:///customers/example/web.xml
  tomcat8081:
    source: puppet:///customers/example/web.xml
  tomcat8082:
    source: puppet:///customers/example/web.xml
  tomcat8083:
    source: puppet:///customers/example/web.xml
```

#### context.xml example

```yaml
tomcatcontext:
  tomcat8080:
    sessionCookiePath: /
    antiJARLocking: true
    antiResourceLocking: true
  tomcat8081:
    sessionCookiePath: /
    antiJARLocking: true
    antiResourceLocking: true
  tomcat8082:
    sessionCookiePath: /
    antiJARLocking: true
    antiResourceLocking: true
  tomcat8083:
    sessionCookiePath: /
    antiJARLocking: true
    antiResourceLocking: true
```

#### update library
```puppet
tomcat::lib { 'tomcat-8080':
  jar_name => 'ecj-4.4.3',
  source => 'puppet:///solr/ecj-4.4.3.jar',
}
```

#### postgres JDBC driver

```
tomcatinstances:
  tomcat_retail01:
    tomcatpw: 123456
    xmx: 1024m
    xms: 1024m
    ajp_port: 9509
    maxpermsize: 384m
    heapdump_oom_dir: /opt/applogs/RETAIL01
  tomcat_retail50:
    tomcatpw: 123456
    xmx: 1024m
    xms: 1024m
    ajp_port: 9510
    maxpermsize: 384m
    heapdump_oom_dir: /opt/applogs/RETAIL50
tomcatdriverpostgres:
  tomcat_retail01: {}
  tomcat_retail50: {}
```

### known errors

#### error installing tomcat native library

The following error means that you need to install the devel package for java, for example **java-1.7.0-openjdk-devel**:

```
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: dirname: missing operand
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: Try 'dirname --help' for more information.
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: dirname: missing operand
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: Try 'dirname --help' for more information.
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: dirname: missing operand
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: Try 'dirname --help' for more information.
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking build system type... x86_64-unknown-linux-gnu
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking host system type... x86_64-unknown-linux-gnu
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking target system type... x86_64-unknown-linux-gnu
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking for a BSD-compatible install... /usr/bin/install -c
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking for working mkdir -p... yes
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: Tomcat Native Version: 1.1.33
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking for chosen layout... tcnative
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking for APR... yes
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns:   setting CC to "gcc"
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns:   setting CPP to "gcc -E"
Notice: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: checking for JDK location (please wait)... configure: error: Not a directory:
Error: bash -c "./configure --with-apr=/usr/bin/apr-1-config --with-java-home=$(dirname $(dirname $(dirname $(find / -xdev -iname jni_md.h | head -n1))))" returned 1 instead of one of [0]
Error: /Stage[main]/Tomcat/Exec[configure native library /usr/local/src]/returns: change from notrun to 0 failed: bash -c "./configure --with-apr=/usr/bin/apr-1-config --with-java-home=$(dirname $(dirname $(dirname $(find / -xdev -iname jni_md.h | head -n1))))" returned 1 instead of one of [0]
```

## Reference

### Global variables

* **eyptomcat::shutdowncommand**: Defines a string to be used to shutdown tomcat (default: SHUTDOWN)

### classes

#### tomcat
* installation options (at least one is required):
  * **tomcat_src**: resource with the tomcat package (default: undef)
  * **tomcat_url**: URL to download the tomcat package (default: undef)
* other options:
  * **manage_tomcat_user**: Manage or not the **tomcat_user** user (default: true)
  * **tomcat_user**: User to run tomcat (default: tomcat)
  * **tomcat_user_home**: tomcat user home dir (default: /home/tomcat)
  * **tomcat_user_shell**: tomcat user shell (default: /bin/bash)
  * **catalina_home**: where to install tomcat (default: /opt/tomcat-home)
  * **srcdir**: Place to store .tar.gz and other temporal files (default: /usr/local/src)
  * **nativelibrary**: Install tomcat native library (default: true)

### defines

#### tomcat::instance

* **tomcatpw**: Password for tomcat GUI user (default: *password*, **must be changed**)
* **catalina_base**          = "/opt/${name}",
* **instancename**           = $name,
* **pwdigest**: Hashing algorithm for tomcat-users.xml file, valid values: sha, plaintext (default: sha)
* **tomcat_user**            = $tomcat::params::default_tomcat_user,
* **server_info**: server identification for this version of Tomcat (default: .)
* **server_number**: server's version number (default: .)
* **server_built**: server built time for this version of Tomcat (default: .)
* **xmx**: JVM max memory: (default: 512m)
* **xms**: JVM start memory: (default: 512m)
* **maxpermsize**: JVM -XX:MaxPermSize (if available): (default: 512m)
* **permsize**: JVM -XX:PermSize (default: undef)
* **shutdown_port**: shutdown port (default: 8005)
* **shutdown_address**: shutdown listen address (default: 127.0.0.1)
* **ajp_port**: AJP listen port (default: undef)
* **connector_port**: HTTP connector port (default: 8080)
* **jmx_port**: JMX listen port (default: 8999)
* **redirectPort**           = '8443',
* **realms**                 = undef,
* **values**                 = undef,
* **errorReportValveClass**  = undef,
* **maxThreads**: tomcat max threads (default: 150)
* **minSpareThreads**        = '4',
* **connectionTimeout**      = '20000',
* **lockoutrealm**           = true,
* **userdatabase**           = true,
* **extra_vars**             = undef,
* **system_properties**      = undef,
* **rmi_server_hostname**    = undef,
* **catalina_rotate**: if eyp-logrotate is available defines a daily catalina.out rotation with this value retention (default: 15)
* **catalina_size**: if eyp-logrotate is available defines a max size to rotate catalina.out (default: 100M)
* **heapdump_oom_dir**: heapdump dir, if defined enables heapdumping (default: undef)
* **install_tomcat_manager** = true,
* **shutdown_command**: shutdown command for the shutdown port (default: eyptomcat::shutdowncommand which, by default, is SHUTDOWN)
* **java_library_path**: -Djava.library.path (default: undef)
* **java_home**              = undef,
* **webapps_owner**: webapps folder owner
* **webapps_group**: webapps folder group
* **webapps_mode**: webapps folder mode

#### tomcat::driver::postgres

Install postgres driver for a given tomcat instance:

* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)
* **jdbc_version**     = '4',
* **postgres_version** = '9.2',
* **srcdir**           = '/usr/local/src',
* **ensure**           = 'present',

#### tomcat::authenticators

* **basic**         = 'org.apache.catalina.authenticator.BasicAuthenticator',
* **form**          = 'org.apache.catalina.authenticator.FormAuthenticator',
* **clientcert**    = 'org.apache.catalina.authenticator.SSLAuthenticator',
* **digest**        = 'org.apache.catalina.authenticator.DigestAuthenticator',
* **none**          = 'org.apache.catalina.authenticator.NonLoginAuthenticator',
* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)

#### tomcat::context

* **sessionCookiePath**   = undef,
* **watchedResource**     = 'WEB-INF/web.xml',
* **manager**             = '',
* **antiJARLocking**      = false,
* **antiResourceLocking** = false,
* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)

#### tomcat::jaas

* **app**,
* **provider**,
* **filter**,
* **username**      = 'tomcat',
* **password**      = 'tomcat',
* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)

#### tomcat::jndi

* **ldapservers**,
* **ldapbase**,
* **ldapadmin**,
* **ldapadminpassword**,
* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)

#### tomcat::lib

* **jar_name**,
* **source**        = undef,
* **file_ln**       = undef,
* **purge_old**: purge other versions of this library (default: true)
* **ensure**        = 'present',
* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)

#### tomcat::libstarball

* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)
* **source**,
* **libstarballname** = $name,
* **purge_old**       = false,

#### tomcat::properties

* **source**,
* **properties_file**,
* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)

#### tomcat::resource

* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)
* **resource_type**
* **resource_name**,
* **factory**                         = undef,
* **driver_class_name**               = undef,
* **resource_url**                    = undef,
* **username**                        = undef,
* **password**                        = undef,
* **initial_size**                    = undef,
* **max_active**                      = undef,
* **max_idle**                        = undef,
* **min_idle**                        = undef,
* **validation_query**                = undef,
* **min_evictable_idletimemillis**    = undef,
* **time_between_evictionrunsmillis** = undef,
* **numtests_per_evictionrun**        = undef,
* **init_sql**                        = undef,
* **auth**                            = undef,
* **location**                        = undef,

#### tomcat::webxml

* **source**,
* **catalina_base**: catalina_base for the tomcat instance (default: /opt/${resource's name})
* **servicename**: tomcat's servicename (default: resource's name)

## Limitations

Tested on:
* CentOS 5
* CentOS 6
* CentOS 7
* Ubuntu 14.04

But should work anywhere

## Development

We are pushing to have acceptance testing in place, so any new feature must
have tests to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
