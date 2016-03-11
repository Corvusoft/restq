# language: en

Feature: Accept-Language request-header field
    In order to specify an acceptable language for the response
    As a resource owner
    I want a resource that processes the Accept-Language request-header field

    Scenario Outline: Valid accept-language field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "bb83a7f9-a56f-4084-bfb8-7b82bffad9a1"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "bb83a7f9-a56f-4084-bfb8-7b82bffad9a1" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low. "
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: application/json, Accept-Language: en, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Allow" header value "OPTIONS"
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

    Scenario Outline: Invalid accept-language field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "2027e348-6709-4536-9b08-9a48129e3400"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "2027e348-6709-4536-9b08-9a48129e3400" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low. "
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: application/json, Accept-Language: es, Host: localhost:1984"
        Then I should see a response status code of "406" "Not Acceptable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "260"
        And I should see a "Content-MD5" header value "d1684142068bbbb54d8b2b353abacdc6"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                                                                                  "
        "     "type": "error",                                                                                                                                                                         "
        "     "code": 40006,                                                                                                                                                                           "
        "     "status": 406,                                                                                                                                                                           "
        "     "title": "Not Acceptable",                                                                                                                                                               "
        "     "message": "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept-language header sent in the request." "
        "   }                                                                                                                                                                                          "
        " }                                                                                                                                                                                            "
        """

    Scenario Outline: Abscent accept-language field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "cb420f00-f189-4b82-be31-f9273e4b1acc"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "cb420f00-f189-4b82-be31-f9273e4b1acc" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low. "
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Allow" header value "OPTIONS"
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

    Scenario Outline: Empty accept-language field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "d3530f0e-f2e9-499a-94e3-5cfe488bdc90"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "d3530f0e-f2e9-499a-94e3-5cfe488bdc90" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low. "
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: application/json, Accept-Language: , Host: localhost:1984"
        Then I should see a response status code of "406" "Not Acceptable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "260"
        And I should see a "Content-MD5" header value "d1684142068bbbb54d8b2b353abacdc6"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                                                                                  "
        "     "type": "error",                                                                                                                                                                         "
        "     "code": 40006,                                                                                                                                                                           "
        "     "status": 406,                                                                                                                                                                           "
        "     "title": "Not Acceptable",                                                                                                                                                               "
        "     "message": "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept-language header sent in the request." "
        "   }                                                                                                                                                                                          "
        " }                                                                                                                                                                                            "
        """

    Scenario Outline: Wildcard accept-language field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "e67e690a-b1cf-41f1-9120-2dd0e434ffc8"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "e67e690a-b1cf-41f1-9120-2dd0e434ffc8" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low. "
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: application/json, Accept-Language: *, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Allow" header value "OPTIONS"
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
