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

### init script usage

#### options

```
[root@ldapm ~]# /etc/init.d/tomcat-8080
Usage: /etc/init.d/tomcat-8080 start | stop | status | threadump | heapdump <file>
```

#### threadump

Will create a thread dump on catalina.out

```
# /etc/init.d/tomcat-8080 threadump
thread dump - OK
```

For example:

```
Full thread dump OpenJDK 64-Bit Server VM (25.101-b13 mixed mode):

"ajp-bio-8888-AsyncTimeout" #20 daemon prio=5 os_prio=0 tid=0x00007f71343c7000 nid=0x226f waiting on condition [0x00007f7120fab000]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
	at java.lang.Thread.sleep(Native Method)
	at org.apache.tomcat.util.net.JIoEndpoint$AsyncTimeout.run(JIoEndpoint.java:152)
	at java.lang.Thread.run(Thread.java:745)

"http-bio-8080-AsyncTimeout" #18 daemon prio=5 os_prio=0 tid=0x00007f71343c3800 nid=0x226d waiting on condition [0x00007f71211ad000]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
	at java.lang.Thread.sleep(Native Method)
	at org.apache.tomcat.util.net.JIoEndpoint$AsyncTimeout.run(JIoEndpoint.java:152)
	at java.lang.Thread.run(Thread.java:745)

"ContainerBackgroundProcessor[StandardEngine[Catalina]]" #16 daemon prio=5 os_prio=0 tid=0x00007f71343b2800 nid=0x226b waiting on condition [0x00007f71213af000]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
	at java.lang.Thread.sleep(Native Method)
	at org.apache.catalina.core.ContainerBase$ContainerBackgroundProcessor.run(ContainerBase.java:1513)
	at java.lang.Thread.run(Thread.java:745)

"GC Daemon" #13 daemon prio=2 os_prio=0 tid=0x00007f7134307800 nid=0x225c in Object.wait() [0x00007f7122d01000]
   java.lang.Thread.State: TIMED_WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000e16a8560> (a sun.misc.GC$LatencyLock)
	at sun.misc.GC$Daemon.run(GC.java:117)
	- locked <0x00000000e16a8560> (a sun.misc.GC$LatencyLock)

(...)

"Finalizer" #3 daemon prio=8 os_prio=0 tid=0x00007f7134089800 nid=0x220a in Object.wait() [0x00007f7123eaa000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000e0008ee0> (a java.lang.ref.ReferenceQueue$Lock)
	at java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:143)
	- locked <0x00000000e0008ee0> (a java.lang.ref.ReferenceQueue$Lock)
	at java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:164)
	at java.lang.ref.Finalizer$FinalizerThread.run(Finalizer.java:209)

"Reference Handler" #2 daemon prio=10 os_prio=0 tid=0x00007f7134085000 nid=0x2209 in Object.wait() [0x00007f7123fab000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000e0006b50> (a java.lang.ref.Reference$Lock)
	at java.lang.Object.wait(Object.java:502)
	at java.lang.ref.Reference.tryHandlePending(Reference.java:191)
	- locked <0x00000000e0006b50> (a java.lang.ref.Reference$Lock)
	at java.lang.ref.Reference$ReferenceHandler.run(Reference.java:153)

"main" #1 prio=5 os_prio=0 tid=0x00007f7134009800 nid=0x2203 runnable [0x00007f713af9b000]
   java.lang.Thread.State: RUNNABLE
	at java.net.PlainSocketImpl.socketAccept(Native Method)
	at java.net.AbstractPlainSocketImpl.accept(AbstractPlainSocketImpl.java:409)
	at java.net.ServerSocket.implAccept(ServerSocket.java:545)
	at java.net.ServerSocket.accept(ServerSocket.java:513)
	at org.apache.catalina.core.StandardServer.await(StandardServer.java:453)
	at org.apache.catalina.startup.Catalina.await(Catalina.java:777)
	at org.apache.catalina.startup.Catalina.start(Catalina.java:723)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.apache.catalina.startup.Bootstrap.start(Bootstrap.java:321)
	at org.apache.catalina.startup.Bootstrap.main(Bootstrap.java:455)

"VM Thread" os_prio=0 tid=0x00007f713407b800 nid=0x2208 runnable

"VM Periodic Task Thread" os_prio=0 tid=0x00007f71341a5800 nid=0x2253 waiting on condition

JNI global references: 51

Heap
 def new generation   total 157248K, used 100655K [0x00000000e0000000, 0x00000000eaaa0000, 0x00000000eaaa0000)
  eden space 139776K,  72% used [0x00000000e0000000, 0x00000000e624bfd8, 0x00000000e8880000)
  from space 17472K,   0% used [0x00000000e8880000, 0x00000000e8880000, 0x00000000e9990000)
  to   space 17472K,   0% used [0x00000000e9990000, 0x00000000e9990000, 0x00000000eaaa0000)
 tenured generation   total 349568K, used 0K [0x00000000eaaa0000, 0x0000000100000000, 0x0000000100000000)
   the space 349568K,   0% used [0x00000000eaaa0000, 0x00000000eaaa0000, 0x00000000eaaa0200, 0x0000000100000000)
 Metaspace       used 15177K, capacity 15452K, committed 15744K, reserved 1062912K
  class space    used 1547K, capacity 1609K, committed 1664K, reserved 1048576K
```

#### heapdump

Requires **jmap** installed

```
# /etc/init.d/tomcat-8080 heapdump heap.bin
Dumping heap to /tmp/hsperfdata_tomcat/heap.bin ...
Heap dump file created
```


### typical configuration options

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

* service options:
  * **ensure**                 = 'running',
  * **manage_service**         = true,
  * **manage_docker_service**  = true,
  * **enable**                 = true,
* other options:
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

### TODO

* rename variables with uppercase letters
* remove disable_variable_is_lowercase from Rakefile (once variables with uppercase letters are removed)
* optionally: thread dump before killing it (kill -3)

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
