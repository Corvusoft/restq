# RestQ [![Build Status](https://travis-ci.org/Corvusoft/restq.svg?branch=master)](https://travis-ci.org/Corvusoft/restq) 

----------

HTTP message broker enabling software solutions to decouple, connect and scale. Designed to accommodate guaranteed delivery, asynchronous processing, non-blocking operations, push notifications, worker queues, and many more enterprise patterns.

## Features

| Feature | Description |
|---------|-------------| 
| Compliance | Flexibility to address HTTP 1.0/1.1+ compliance. |
| Community  | Active, vibrant and energetic open source community. |
| Support | Commercial support is available from [Corvusoft](http://www.corvusoft.co.uk). |

## Example

See [exchange example](https://github.com/Corvusoft/restq/tree/master/example) for service implementation details.

###### Create Queue
```
curl -XPOST --data='' 'http://localhost:1984/queues'
```
###### Create Subscription
```
curl -XPOST --data='' 'http://localhost:1984/subscriptions'
```
###### Create Message
```
curl -XPOST --data='' 'http://localhost:1984/messages'
```

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

The [lettuce.py](http://lettuce.it) behaviour driven development tool is required to run this suite of tests.

```bash
cd restq
./distribution/example/http_example

lettuce test/acceptance
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
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |              Publish/Subscribe                  |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |         Custom Formatters (JSON,YAML,XML)       |     complete    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |      Multi-Threaded service capability          |      pending    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |       Bind Service to specific Address          |      pending    |
|   [1.0](https://github.com/Corvusoft/restq/milestones/1.0)  |              API Documentation                  |      pending    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |             Secure Socket Layer                 |      pending    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |     Simultaneous Network Ports (HTTP/HTTPS)     |      pending    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |               Signal Handling                   |      pending    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |                 Worker Queue                    |      pending    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |                 Queue Features                  |      pending    |
|   [1.5](https://github.com/Corvusoft/restq/milestones/1.5)  |            Subscription Features                |      pending    |
|   [2.0](https://github.com/Corvusoft/restq/milestones/2.0)  |                 Compression                     |      pending    |
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
