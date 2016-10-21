# CHANGELOG

## 0.3.18

* tomcat::context changed to concat
* serverxml concat reorder
* modified startup, shutdown and configtest scripts to be able to work in a **CATALINA_HOME**==**CATALINA_BASE** environments
* tomcat configtest **WARNING** init script it's going to change, service will be reloaded unless **manage_service** is set to **false**
* added the following tomcat::instance options **WARNING** server.xml it's going to change, service will be reloaded unless **manage_service** is set to **false**
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
