# RestQ [![Build Status](https://travis-ci.org/Corvusoft/restq.svg?branch=master)](https://travis-ci.org/Corvusoft/restq) 

----------

HTTP message broker enabling software solutions to decouple, connect and scale. Designed to accommodate guaranteed delivery, asynchronous processing, non-blocking operations, push notifications, data discovery, worker queues, and many more enterprise patterns.

## Features

| Feature | Description |
|---------|-------------| 
| Open Standards | Configuration of the broker and message generation is all done via a HTTP RESTful application programming interface. |
| Discovery | The ability to query and discover Queues/Subscriptions of importance.  |
| Decoration | Queues/Subscriptions can be annotated with properties to tag, categorise and aid discovery. |
| PubSub  | Support for the Publish-Subscribe messaging pattern. |
| Message Integrity | Content-MD5 end-to-end message integrity checking (MIC). |
| Logging |	Customise how and where log entries are created. |
| IPv4/IPv6 |	Internet Protocol Version 4/6 Network Support. |
| Architecture | Asynchronous single or multi-threaded architecture, capable of addressing the C10K problem. |
| Address Binding |	Bind HTTP and/or HTTPS services to separate IP addresses. |
| Community  | Active, vibrant and energetic open source community. |
| Support | Commercial support is available from [Corvusoft](http://www.corvusoft.co.uk). |

## Example

See the [exchange example](https://github.com/Corvusoft/restq/tree/master/example) for service implementation details.

###### Create Queue
```
curl -XPOST http://localhost:1984/queues --data '{ "data": { "name": "biz-logic-events" } }' -H'Content-Type: application/json' -H'Accept: application/json' -H'Host: localhost:1984' -v
```

```
HTTP/1.1 201 Created
Expires: 0
Pragma: no-cache
Connection: close
Accept-Ranges: none
Content-Length: 192
Server: corvusoft/restq
ETag: "58929204637930416000"
Allow: GET,PUT,HEAD,DELETE,OPTIONS
Date: Mon, 07 Mar 2016 02:54:57 GMT
Content-MD5: 1FDBFBECFF809C2EC325ACDC83EF7A26
Content-Type: application/json; charset=utf-8
Last-Modified: Mon, 07 Mar 2016 02:54:57 GMT
Cache-Control: private,max-age=0,no-cache,no-store
Location: http://localhost:1984/queues/040ab769-e4ba-40bb-886b-37bb6800baed
Vary: Accept,Accept-Encoding,Accept-Charset,Accept-Language
{ "data": {
    "type": "queue",
    "modified": 1457319297,
    "name": "biz-logic-events",
    "revision": "58929204637930416000",
    "origin": "[::ffff:127.0.0.1]:61957",
    "key": "040ab769-e4ba-40bb-886b-37bb6800baed"
  }
}
```

###### Create Subscription
```
curl -XPOST http://localhost:1984/subscriptions --data '{ "data": { "endpoint": "http://localhost:1985", "queues": [ "040ab769-e4ba-40bb-886b-37bb6800baed" ] } }' -H'Content-type: application/json' -H'Accept: application/json' -H'Host: localhost:1984' -v
```

```
HTTP/1.1 201 Created
Expires: 0
Pragma: no-cache
Connection: close
Content-Length: 208
Accept-Ranges: none
Server: corvusoft/restq
ETag: "16962065903070504062"
Allow: GET,PUT,HEAD,DELETE,OPTIONS
Date: Mon, 07 Mar 2016 03:07:04 GMT
Last-Modified: Mon, 07 Mar 2016 03:07:04 GMT
Content-MD5: 3A910593944580831B7797F63244505B
Content-Type: application/json; charset=utf-8
Cache-Control: private,max-age=0,no-cache,no-store
Vary: Accept,Accept-Encoding,Accept-Charset,Accept-Language
Location: http://localhost:1984/subscriptions/3a627a94-66da-45e7-a7fb-c700fd877e58
{ "data": {
    "type": "subscription"
    "modified": 1457320024,
    "revision": "16962065903070504062",
    "endpoint": "http://localhost:1985",
    "origin": "[::ffff:127.0.0.1]:62036",
    "key": "3a627a94-66da-45e7-a7fb-c700fd877e58",
  }
}
```
###### Create Message
```
curl -XPOST --data 'Payroll server is low on disk space.' 'http://localhost:1984/queues/040ab769-e4ba-40bb-886b-37bb6800baed/messages' -H'Content-Type: text/plain' -H'Accept: application/json' -H'Host: localhost:1984' -v
```

or
```
curl -XPOST --data 'Payroll server is low on disk space.' 'http://localhost:1984/messages?name=biz-logic-events' -H'Content-Type: text/plain' -H'Accept: application/json' -H'Host: localhost:1984' -v
```

```
HTTP/1.1 202 Accepted
Expires: 0
Allow: OPTIONS
Pragma: no-cache
Connection: close
Accept-Ranges: none
Server: corvusoft/restq
Date: Mon, 07 Mar 2016 03:34:06 GMT
Cache-Control: private,max-age=0,no-cache,no-store
Location: /messages/6dbb7894-3f04-4e71-97c0-aefde07fefb5
Vary: Accept,Accept-Encoding,Accept-Charset,Accept-Language
```

Given you have a consumer waiting on the subscription endpoint (http://localhost:1985). You'll see the message dispatched. See [documentation](https://github.com/Corvusoft/restq/tree/master/documentation) and the [acceptance test suite](https://github.com/Corvusoft/restq/tree/master/test/acceptance/features) for further details and configurations.

## License

&copy; 2014-2016 Corvusoft Limited, United Kingdom. All rights reserved. 

The RestQ framework is dual licensed; See [LICENSE](LICENSE) for full details.

## Support

Please contact sales@corvusoft.co.uk, for support and licensing options including bespoke software development, testing, design consultation, training, mentoring and code review.              

## Build

```bash
git clone --recursive https://github.com/corvusoft/restq.git
mkdir restq/build
cd restq/build
cmake [-DBUILD_TESTS=YES] [-DBUILD_EXAMPLES=YES] [-DBUILD_SSL=NO] [-DBUILD_SHARED=YES] [-DCMAKE_INSTALL_PREFIX=/output-directory] ..
make [-j CPU_CORES+1] install
make test
```

You will now find all required components installed in the distribution folder.

Please submit all enhancements, proposals, and defects via the [issue](http://github.com/corvusoft/restq/issues) tracker; Alternatively ask a question on [StackOverflow](http://stackoverflow.com/questions/ask) tagged [#restq](http://stackoverflow.com/questions/tagged/restq).

## Test

The [lettuce.py](http://lettuce.it) behaviour driven development tool is required to run this test suite.

```bash
cd restq
./distribution/example/http_example

lettuce --failfast --random test/acceptance/features
```

The acceptance tests can be located [here](https://github.com/Corvusoft/restq/tree/master/test/acceptance/features). They're also a good starting point for developers wishing to integrate with RestQ.

## Minimum Requirements

|     Resource   |                   Requirement                   |
|:--------------:|:-----------------------------------------------:| 
|     Compiler   |          C++11 compliant or above               |
|        OS      | BSD, Linux, Mac OSX, Solaris, Windows, Raspbian |

## Road Map

|   Milestone   |                   Feature                       |      Status     |
|:-------------:|:-----------------------------------------------:|:---------------:| 
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |         Asynchrounous HTTP Service              |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |             HTTP 1.0/1.1 Compliance             |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |                PubSub Pattern                   |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |               Custom Formatters                 |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |      Multi-Threaded service capability          |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |       Bind Service to specific Address          |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |           Query/Subscription Search             |     complete    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |              API Documentation                  |     complete    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |             Secure Socket Layer                 |     complete    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |     Simultaneous Network Ports (HTTP/HTTPS)     |     complete    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |               Signal Handling                   |     complete    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |             Queue Message Limit                 |     complete    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |           Queue Message Size Limit              |     complete    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |           Queue Subscription Limit              |     complete    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |                 Worker Queue                    |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |              Custom Compression                 |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |          Subscription Header Filters            |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |             Custom Authentication               |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |               Custom Encodings                  |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |             Custom Character Sets               |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |               Custom Dispatches                 |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |                  Localisation                   |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |           Direct/Indirect Messaging             |      pending    |
|   [2.5](https://github.com/Corvusoft/restq/milestones/2.5)  |                 User Interface                  |      pending    |
|   [2.5](https://github.com/Corvusoft/restq/milestones/2.5)  |             Runtime Modifications               |      pending    |
|   [2.5](https://github.com/Corvusoft/restq/milestones/2.5)  |               HTTP 2 compliance                 |      pending    |
|   [2.5](https://github.com/Corvusoft/restq/milestones/2.5)  |            Refactor, Reduce, Reuse              |      pending    |

## Contact

|     Method    |                   Description                  |
|:--------------|:-----------------------------------------------| 
| [Twitter](http://www.twitter.com/corvusoft)                  | Tweet us your questions & feature requests.   |
| support@corvusoft.co.uk                                      | Support related queries.                      |
| sales@corvusoft.co.uk                                        | Sale related queries.                         |
