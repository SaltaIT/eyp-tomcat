# CHANGELOG

## 0.4.8

* tomcat::contextxml: bugfix
* deleted type option from **tomcat::jaas**

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
