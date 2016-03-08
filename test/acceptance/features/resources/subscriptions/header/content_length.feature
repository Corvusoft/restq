# language: en

Feature: Content-Length entity-header field
    In order to interpret the response body
    As a collection owner
    I want a collection that includes the Content-Length entity-header field

    Scenario Outline: Valid content-length field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-Length: 208":
        """
        " { "data": {                                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "201" "Created"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "212"
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
        "     "type": "subscription",                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Invalid content-length field; too small.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-Length: 3":
        """
        " { "data": {                                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "159"
        And I should see a "Content-MD5" header value "8670D665E9701C41D3A3BABA9AB2ED9C"
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
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                "
        "     "type": "error",                                                                       "
        "     "code": 40000,                                                                         "
        "     "status": 400,                                                                         "
        "     "title": "Bad Request",                                                                "
        "     "message": "The exchange is refusing to process the request because it was malformed." "
        "   }                                                                                        "
        " }                                                                                          "
        """

    Scenario Outline: Invalid content-length field; too large.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-Length: 98700":
        """
        " { "data": {                                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see the exchange shutdown the connection after 5 seconds

    Scenario Outline: Abscent content-length field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with only headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "411" "Length Required"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "185"
        And I should see a "Content-MD5" header value "91FB953C1CD977119E980541B598A4C0"
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
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                      "
        "     "type": "error",                                                                                             "
        "     "code": 40011,                                                                                               "
        "     "status": 411,                                                                                               "
        "     "title": "Length Required",                                                                                  "
        "     "message": "The exchange refuses to accept the request without a well defined content-length entity header." "
        "   }                                                                                                              "
        " }                                                                                                                "
        """

    Scenario Outline: Zero content-length field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-Length: 0":
        """
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "159"
        And I should see a "Content-MD5" header value "8670D665E9701C41D3A3BABA9AB2ED9C"
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
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                "
        "     "type": "error",                                                                       "
        "     "code": 40000,                                                                         "
        "     "status": 400,                                                                         "
        "     "title": "Bad Request",                                                                "
        "     "message": "The exchange is refusing to process the request because it was malformed." "
        "   }                                                                                        "
        " }                                                                                          "
        """

    Scenario Outline: Empty content-length field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-Length: ":
        """
        " { "data": {                                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "411" "Length Required"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "185"
        And I should see a "Content-MD5" header value "91FB953C1CD977119E980541B598A4C0"
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
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                      "
        "     "type": "error",                                                                                             "
        "     "code": 40011,                                                                                               "
        "     "status": 411,                                                                                               "
        "     "title": "Length Required",                                                                                  "
        "     "message": "The exchange refuses to accept the request without a well defined content-length entity header." "
        "   }                                                                                                              "
        " }                                                                                                                "
        """

    Scenario Outline: Malformed content-length field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-Length: lkajfw098":
        """
        " { "data": {                                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "411" "Length Required"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "185"
        And I should see a "Content-MD5" header value "91FB953C1CD977119E980541B598A4C0"
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
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                      "
        "     "type": "error",                                                                                             "
        "     "code": 40011,                                                                                               "
        "     "status": 411,                                                                                               "
        "     "title": "Length Required",                                                                                  "
        "     "message": "The exchange refuses to accept the request without a well defined content-length entity header." "
        "   }                                                                                                              "
        " }                                                                                                                "
        """
