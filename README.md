# tomcat

AtlasIT-AM/eyp-tomcat: [![Build Status](https://travis-ci.org/AtlasIT-AM/eyp-tomcat.png?branch=master)](https://travis-ci.org/AtlasIT-AM/eyp-tomcat)

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

## Overview

Multi instance tomcat installation

## Module Description

Multi instance tomcat installation and configuration of:
 * server.xml
   * context, connectors...
 * JVM memory settings
 * context.xml
 * authenticators
 * jaas
 * jndi
 * custom library deployment (tar.gz)
 * web.xml
 * properties

## Setup

### What tomcat affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with tomcat

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
tomcatlibstarballs:
  tomcat8080:
    source: puppet:///customers/example/tomcatlibs.tgz
  tomcat8081:
    source: puppet:///customers/example/tomcatlibs.tgz
  tomcat8082:
    source: puppet:///customers/example/tomcatlibs.tgz
  tomcat8083:
    source: puppet:///customers/example/tomcatlibs.tgz
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
tomcatwebxml:
  tomcat8080:
    source: puppet:///customers/example/web.xml
  tomcat8081:
    source: puppet:///customers/example/web.xml
  tomcat8082:
    source: puppet:///customers/example/web.xml
  tomcat8083:
    source: puppet:///customers/example/web.xml
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

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

We are pushing to have acceptance testing in place, so any new feature should have some test to check both presence and absence of any feature
