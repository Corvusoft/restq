# language: en

Feature: Accept-Charset request-header field
    In order to specify an acceptable character set for the response
    As a resource owner
    I want a resource that processes the Accept-Charset request-header field

    Scenario Outline: Valid accept-charset field.
        Given I have started a message exchange
        When I perform a HTTP "OPTIONS" request to "/*" with headers "Accept: application/json, Accept-Charset: utf-8, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Workers" header value
        And I should see a "Queues" header value
        And I should see a "Messages" header value
        And I should see a "Subscriptions" header value
        And I should see a "Uptime" header value
        And I should see a "CPU" header value
        And I should see a "Memory" header value
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

    Scenario Outline: Invalid accept-charset field.
        Given I have started a message exchange
        When I perform a HTTP "OPTIONS" request to "/*" with headers "Accept: application/json, Accept-Charset: iso-8859-5, Host: localhost:1984"
        Then I should see a response status code of "406" "Not Acceptable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "259"
        And I should see a "Content-MD5" header value "8E246229B3DF5FC57042D77F4C9632E5"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
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
        " { "data": {                                                                                                                                                                                 "
        "     "type": "error",                                                                                                                                                                        "
        "     "code": 40006,                                                                                                                                                                          "
        "     "status": 406,                                                                                                                                                                          "
        "     "title": "Not Acceptable",                                                                                                                                                              "
        "     "message": "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept-charset header sent in the request." "
        "   }                                                                                                                                                                                         "
        " }                                                                                                                                                                                           "
        """

    Scenario Outline: Abscent accept-charset field.
        Given I have started a message exchange
        When I perform a HTTP "OPTIONS" request to "/*" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Workers" header value
        And I should see a "Queues" header value
        And I should see a "Messages" header value
        And I should see a "Subscriptions" header value
        And I should see a "Uptime" header value
        And I should see a "CPU" header value
        And I should see a "Memory" header value
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

    Scenario Outline: Empty accept-charset field.
        Given I have started a message exchange
        When I perform a HTTP "OPTIONS" request to "/*" with headers "Accept: application/json, Accept-Charset: , Host: localhost:1984"
        Then I should see a response status code of "406" "Not Acceptable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "259"
        And I should see a "Content-MD5" header value "8E246229B3DF5FC57042D77F4C9632E5"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
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
        " { "data": {                                                                                                                                                                                 "
        "     "type": "error",                                                                                                                                                                        "
        "     "code": 40006,                                                                                                                                                                          "
        "     "status": 406,                                                                                                                                                                          "
        "     "title": "Not Acceptable",                                                                                                                                                              "
        "     "message": "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept-charset header sent in the request." "
        "   }                                                                                                                                                                                         "
        " }                                                                                                                                                                                           "
        """

    Scenario Outline: Wildcard accept-charset field.
        Given I have started a message exchange
        When I perform a HTTP "OPTIONS" request to "/*" with headers "Accept: application/json, Accept-Charset: *, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Workers" header value
        And I should see a "Queues" header value
        And I should see a "Messages" header value
        And I should see a "Subscriptions" header value
        And I should see a "Uptime" header value
        And I should see a "CPU" header value
        And I should see a "Memory" header value
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
