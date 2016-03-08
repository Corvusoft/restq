# language: en

Feature: Styled Output
    In order to assist client development
    As a software developer
    I want the ability to return human readable output

    Scenario Outline: Read collection with styling.
        Given I have started a message exchange
        When I perform a HTTP "GET" request to "/queues?style=on" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "18"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "ETag" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": [ ] } "
        """

    Scenario Outline: Read collection without styling.
        Given I have started a message exchange
        When I perform a HTTP "GET" request to "/queues?style=off" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "11"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "ETag" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " {"data":[]} "
        """

    Scenario Outline: Create resource with styling.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/queues?style=true" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "201" "Created"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "277"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Location" header value
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Age" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "type": "queue",                               "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Create resource without styling.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/queues?style=false" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "201" "Created"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "195"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Location" header value
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Age" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " {"data":{"name":"acceptance-test","type":"queue"}} "
        """

    Scenario Outline: HTTP error with styling.
        Given I have started a message exchange
        When I perform a HTTP "TRACE" request to "/queues?style=1" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "501" "Not Implemented"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "268"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "34CDC8EE972F98F80B2FC04434964AB2"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Allow" header value "GET,PUT,POST,HEAD,DELETE,OPTIONS"
        And I should see a "Expires" header value "0"
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
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Last-Modified" header value
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

    Scenario Outline: HTTP error without styling.
        Given I have started a message exchange
        When I perform a HTTP "TRACE" request to "/queues?style=0" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "501" "Not Implemented"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "206"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "7242942A42B52C2B6CCF198CBEDF0E4C"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Allow" header value "GET,PUT,POST,HEAD,DELETE,OPTIONS"
        And I should see a "Expires" header value "0"
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
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " {"data":{"type":"error","code":50001,"status":501,"title":"Not Implemented","message":"The exchange is refusing to process the request because the requested method is not implemented within this service."}} "
        """
