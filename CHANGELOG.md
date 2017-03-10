# CHANGELOG

## 0.5.12

* bugfix: **CATALINA_OPTS** loaded twice (catalina.sh & startup.sh)

## 0.5.11

* chown to tomcot for **tomcat::agent**

## 0.5.10

*  **tomcat::properties**: allow custom dir

## 0.5.9

* bugfix mkdir srcdir dependencies on **tomcat::agent**

## 0.5.8

* bugfix: tar name in **tomcat::agent**

## 0.5.7

* added **tomcat::agent::tarball_path** to allow different agent tarballs for multiple instances

## 0.5.5

* bugfix **tomcat::agent**: allow installation agents on multiple instances using the same source tar

## 0.5.4

* **tomcat::agent** in tarball mode: added **--no-same-owner** and **--strip 1**

## 0.5.3

* bugfix tomcat-users.xml not present when userdatabase=false

## 0.5.2

* added variables to deploywar for file ownership and mode:
  * war_owner
  * war_group
  * war_mode

## 0.5.1

* added **tomcat::tomcatrole** as a define (**tomcat::instance** has been rewritten to use it)
* renamed uppercase variables from **tomcat::intance**:
  * **redirectPort** to **redirect_port**
  * **maxThreads** to **max_threads**
  * **minSpareThreads** to **min_spare_threads**
* deleted obsolete variable **connectionTimeout** from **tomcat::instance**

## 0.5.0

* **INCOMPATIBLE CHANGE**: renamed **tomcat::instance** variable **errorReportValveClass** to **error_report_valve_class**
* added variable to customize **ErrorReportValve**:
  * add_error_report_valve_settings (default: true)
  * error_report_valve_show_report (default: false)
  * error_report_valve_show_server_info (default: false)
* added **org.apache.catalina.valves.ErrorReportValve** management (showReport and showServerInfo) to be able to disable stack traces by default
* added variable to enable/disable JasperListener

## 0.4.53

* bugfix tomcat-users.xml dependency

## 0.4.52

* **INCOMPATIBLE CHANGE**: added variable **custom_webxml** to **tomcat::instance** (default: false) it copies web.xml from catalina_home to catalina_base (if you need to use a **custom web.xml** you are going to need to set it to **true**)

## 0.4.51

* added **tomcat::tomcatuser** (tomcat-user.xml user management)
* **tomcat::instance** rewritten to use **tomcat::tomcatuser**

## 0.4.50

* added tar as a installation method for tomcat::agent (changed behaviour)

## 0.4.49

* added **catalina_logrotate_ensure** to enable/disable (present/absent) logrotate configuration

## 0.4.48

* added ensure for **tomcat::jaas**, **tomcat::krb5**, **tomcat::jndi** and **tomcat::login**

## 0.4.47

* lint AD SSO

## 0.4.46

* tomcat AD SSO cleanup

## 0.4.45

* added variable for **pid_file**

## 0.4.44

* logging properties:
  * added default template for logging properties
  * **INCOMPATIBLE CHANGE**: changed catalina.out default date format to ISO 8601
  * added -Djava.util.logging.config.file to be able to configure an custom file
* bugfix **connector_ajp_packet_size**
* variables enctypes for krb5

## 0.4.43

* deleted **eyp_tomcat_check_jdk**

## 0.4.42

* template krb5, rc4 only

## 0.4.41

* template krb5
  * arcfour-hmac-md5,aes256-cts-hmac-sha1-96,aes128-cts,rc4-hmac

## 0.4.40

* added **tomcat::valve**

## 0.4.39

* dropped debug for JNDI realm

## 0.4.38

* lint

## 0.4.37

* added JNDI realm debug

## 0.4.36

* enforced group ID if tomcat_user_uid is set

## 0.4.35

* PID path back to /var/run
* changed startup systemd's startup user

## 0.4.33

* bugfix systemd PID

## 0.4.32

* variable tomcat_user_uid to define tomcat's uid
* added "user" variable to **tomcat::resource**
* changed PID path

## 0.4.31

* changed systemd's init script to force /bin/bash

## 0.4.30

* updated systemd to use PIDfile

## 0.4.29

* template krb5 lowercase and weak crypto to false

## 0.4.28

* tomcat::krb5 added allow_weak_crypto

## 0.4.27

* added option add_root_ln to tomcat::deploywar to create a symlink for ROOT.war

## 0.4.26

* init script: cd to CATALINA_BASE

## 0.4.25

* jaas typo

## 0.4.23

* pushing back use **tomcat:jvmproperty** for java.security.auth.login.config instead of a template

## 0.4.22

* bugfix **tomcat::jvmproperty**

## 0.4.21

* added debug option for jaas


## 0.4.20

* rollback use **tomcat:jvmproperty** for java.security.auth.login.config instead of a template file due to this:
```
# puppet agent --test
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Loading facts
Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Duplicate declaration: Tomcat::Jvmproperty[java.security.auth.login.config] is already declared in file /etc/instance-puppet-modules/tomcat/manifests/jaas.pp:74; cannot redeclare at /etc/instance-puppet-modules/tomcat/manifests/jaas.pp:74 on node demotomcat.systemadmin.es
Warning: Not using cache on failed catalog
Error: Could not retrieve catalog; skipping run

```

## 0.4.19

* added defaults for **tomcat::realm::jndi**
* added **tomcat::jvmproperty**
* added app_base to **tomcat::deploywar**
* improved acceptance testing
* added concat serverxml: 29 - end host
* added **tomcat::alias**
* added debian 8 to acceptance testing
* **tomcat::jaas** rewritten to use **tomcat:jvmproperty** for java.security.auth.login.config instead of a template file
* **tomcat::krb5**:
  * added **debug** and **forwardable** options
  * added java.security.krb5.conf as a **tomcat::jvmproperty**
  * added javax.security.auth.useSubjectCredsOnly as **tomcat::jvmproperty**

## 0.4.18

* minor change krb5 template

## 0.4.17

* added default_keytab

## 0.4.15

* contextxml lint

## 0.4.14

* rewrite servei instancia

## 0.4.12

* keytab full path

## 0.4.11

* added **tomcat::deploywar**

## 0.4.10

* bugfix krb5 file naming

## 0.4.9

* **tomcat::contextxml::environment** and **tomcat::contextxml::resourcelink** aligment
* bugfix SPN **tomcat::jaas**
* **tomcat::krb5** added keytab_source

## 0.4.8

* tomcat::contextxml: bugfix
* deleted type option from **tomcat::jaas**
* renaming variables from **tomcat::jaas** for krb5 to a more meaningful name

## 0.4.7

* tomcat::contextxml:
  * estil **tomcat::contextxml**
  * **INCOMPATIBLE CHANGE**: manager default value changed from '' to undef

## 0.4.6

* bugfix **tomcat::contextxml**

## 0.4.5

* added enable_default_access_log to be able to disable default Valve

## 0.4.4

* **tomcat::context**:
  * reloadable set by default to true
  * path is now mandatory
  * path related bugfix

## 0.4.3

* flag to be able to disable version_logger_listener

## 0.4.2

* added option **packetSize** (**connector_ajp_packet_size**) for the **AJP connector**

## 0.4.1

**Major release** with **incompatible changes**, please review this list carefully:
* added combined realm by default to allow multiple realms (**COMPATIBILITY ISSUE**: **LockOutRealm** cannot be enabled on **tomcat 7.0.32 or older** because we are using **CombinedRealm** by default)
* added **jvmRoute** support as **jvm_route**
* **server.xml** concat rewrite - it's going to change due to this, service will be restarted unless **manage_service** is set to **false**
* **tomcat::resource** added max_wait
* added **tomcat::realm::jndi**
* added **tomcat::catalinapolicy**
* added **tomcat::login**
* added **tomcat::context** for **server.xml** context definition
* **tomcat::context** renamed to **tomcat::contextxml**:
  * **INCOMPABLE CHANGE** variable rename:
    * **watchedResource** to **watched_resource**
    * **antiJARLocking** to **anti_jar_locking**, changed default value from **false** to **undef**
    * **sessionCookiePath** to **session_cookie_path**
    * **antiResourceLocking** to **anti_resource_locking**, changed default value from **false** to **undef**
* addded **tomcat::loggingproperties** (from source file)
* modified startup, shutdown and configtest scripts to be able to work in a **CATALINA_HOME**==**CATALINA_BASE** environments
* tomcat configtest **WARNING** init script it's going to change, service will be reloaded unless **manage_service** is set to **false**
* added the following tomcat::instance options **WARNING** server.xml
  * connector_http_max_header_size
  * connector_http_max_threads
  * connector_http_min_spare_threads
  * connector_http_max_spare_threads
  * connector_http_enable_lookups
  * connector_http_accept_count
  * **WARNING** renamed **connectionTimeout** to **connector_http_connection_timeout**
  * connector_http_disable_upload_timeout
  * connector_http_uri_encoding
  * xml_validation
  * xml_namespace_aware

## 0.3.17

* *bugfix*: added notification on systemd changes

## 0.3.16

* *bugfix*: avoid service notifications if manage_service=false

## 0.3.15

* *bugfix*: honor userdatabase setting

## 0.3.12

* added **path** and **session_cookie_name** to **tomcat::context**

## 0.3.11

* added configurable HTTP Server header (**connector_http_server**) to **tomcat::instance**

## 0.3.10

* Added **tomcat::agent**

## 0.3.9

* **SERVICE RESTART REQUIRED** (unless manage_service=false) - added headpdump and treadump functions to init script:

```
Info: Computing checksum on file /etc/init.d/tomcat-8081
Info: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/File[/etc/init.d/tomcat-8081]: Filebucketed /etc/init.d/tomcat-8081 to puppet with sum b06f4ada432b23db81a6c8d33a311e78
Notice: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/File[/etc/init.d/tomcat-8081]/content: content changed '{md5}b06f4ada432b23db81a6c8d33a311e78' to '{md5}ecb7c3003a37ac6bc8f3940adc1cc717'
Info: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/File[/etc/init.d/tomcat-8081]: Scheduling refresh of Service[tomcat-8081]
Notice: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/Service[tomcat-8081]: Triggered 'refresh' from 1 events
```

## (...)

## 0.3.0

* **INCOMPATIBLE CHANGE**: variable rename:
  * **LockOutRealm to lockoutrealm**
  * **UserDatabase** to **userdatabase**
