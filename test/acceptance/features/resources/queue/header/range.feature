# language: en

Feature: Range request-header field
    In order to indicate that particular server behaviors are not supported
    As a exchange developer
    I want a resource that responds correctly to the Range request-header field

    Scenario Outline: HTTP GET range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "ca3a7855-73da-4f34-a8bd-d34eb165d8c0", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/queues/ca3a7855-73da-4f34-a8bd-d34eb165d8c0" with headers "Accept: application/json, Range: bytes=3744-, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "336"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "ca3a7855-73da-4f34-a8bd-d34eb165d8c0", "
        "     "type": "queue",                               "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: HTTP HEAD range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "ca727095-6cfd-468d-9b42-26b0af3ce023", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "HEAD" request to "/queues/ca727095-6cfd-468d-9b42-26b0af3ce023" with headers "Accept: application/json, Range: bytes=3744-, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "336"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response

    Scenario Outline: HTTP CONNECT range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "a1c2ecf1-dc67-4801-a6a2-ee7a9acddd62", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "CONNECT" request to "/queues/a1c2ecf1-dc67-4801-a6a2-ee7a9acddd62" with headers "Accept: application/json, Range: bytes=3744-, Host: localhost:1984"
        Then I should see a response status code of "501" "Not Implemented"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "206"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "7242942a42b52c2b6ccf198cbedf0e4c"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,POST,HEAD,DELETE,OPTIONS"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                           "
        "     "type": "error",                                                                                                                  "
        "     "code": 50001,                                                                                                                    "
        "     "status": 501,                                                                                                                    "
        "     "title": "Not Implemented",                                                                                                       "
        "     "message": "The exchange is refusing to process the request because the requested method is not implemented within this service." "
        "   }                                                                                                                                   "
        " }                                                                                                                                     "
        """

    Scenario Outline: HTTP DELETE range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "6db284e2-b2a2-4fe9-a2ac-56b2ade7826f", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "DELETE" request to "/queues/6db284e2-b2a2-4fe9-a2ac-56b2ade7826f" with headers "Accept: application/json, Range: bytes=3744-, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Location" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response

    Scenario Outline: HTTP PATCH range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "fcfe99f8-a87c-4ccb-9237-96f117455e16", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PATCH" request to "/queues/fcfe99f8-a87c-4ccb-9237-96f117455e16" with headers "Accept: application/json, Range: bytes=3744-, Host: localhost:1984"
        Then I should see a response status code of "501" "Not Implemented"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "206"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "7242942a42b52c2b6ccf198cbedf0e4c"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,POST,HEAD,DELETE,OPTIONS"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                           "
        "     "type": "error",                                                                                                                  "
        "     "code": 50001,                                                                                                                    "
        "     "status": 501,                                                                                                                    "
        "     "title": "Not Implemented",                                                                                                       "
        "     "message": "The exchange is refusing to process the request because the requested method is not implemented within this service." "
        "   }                                                                                                                                   "
        " }                                                                                                                                     "
        """

    Scenario Outline: HTTP PUT resource with no change required, range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "351c5208-a9ea-46c2-b775-3514c6c2f891", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/351c5208-a9ea-46c2-b775-3514c6c2f891" with headers "Content-Type: application/json, Accept: application/json, Range: bytes=3744-, Host: localhost:1984":
        """
        " { "data": {                   "
        "     "name": "acceptance-test" "
        "   }                           "
        " }                             "
        """
        Then I should see a response status code of "204" "No Content"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Last-Modified" header value
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Allow" header value
        And I should not see a "Location" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response

    Scenario Outline: HTTP TRACE range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "6d9fe6d3-c920-471c-856d-0aee92d67e68", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "TRACE" request to "/queues/6d9fe6d3-c920-471c-856d-0aee92d67e68" with headers "Accept: application/json, Range: bytes=3744-, Host: localhost:1984"
        Then I should see a response status code of "501" "Not Implemented"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "206"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "7242942a42b52c2b6ccf198cbedf0e4c"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,POST,HEAD,DELETE,OPTIONS"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                           "
        "     "type": "error",                                                                                                                  "
        "     "code": 50001,                                                                                                                    "
        "     "status": 501,                                                                                                                    "
        "     "title": "Not Implemented",                                                                                                       "
        "     "message": "The exchange is refusing to process the request because the requested method is not implemented within this service." "
        "   }                                                                                                                                   "
        " }                                                                                                                                     "
        """

    Scenario Outline: HTTP POST range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "23b5973f-2116-4872-bea9-c01620451b99", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "POST" request to "/queues/23b5973f-2116-4872-bea9-c01620451b99" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Range: bytes=3744-":
        """
        " { "data": {                              "
        "     "name": "additional-acceptance-test" "
        "   }                                      "
        " }                                        "
        """
        Then I should see a response status code of "405" "Method Not Allowed"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "203"
        And I should see a "Content-MD5" header value "d79174f3477fcb685eb896acdfd5fbe4"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                     "
        "     "type": "error",                                                                                                            "
        "     "code": 40005,                                                                                                              "
        "     "status": 405,                                                                                                              "
        "     "title": "Method Not Allowed",                                                                                              "
        "     "message": "The exchange is refusing to process the request because the requested method is not allowed for this resource." "
        "   }                                                                                                                             "
        " }                                                                                                                               "
        """

    Scenario Outline: HTTP OPTIONS range field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "449ab99c-8eed-4e5f-8bd3-c7ca5ccefa12", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "OPTIONS" request to "/queues/449ab99c-8eed-4e5f-8bd3-c7ca5ccefa12" with headers "Accept: application/json, Host: localhost:1984, Range: bytes=3744-"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Location" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response
