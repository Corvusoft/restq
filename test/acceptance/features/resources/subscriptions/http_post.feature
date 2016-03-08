# language: en

Feature: HTTP POST
    In order to create new resource instances
    As a collection owner
    I want to allow the HTTP POST method

    Scenario Outline: Create single resource.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                             "
        "     "endpoint": "http://localhost:8080" "
        "   }                                     "
        " }                                       "
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

    Scenario Outline: Create multiple resources.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                  "
        "    { "endpoint": "http://localhost:8080" },  "
        "    { "endpoint": "http://localhost:80" }     "
        "   ]                                          "
        " }                                            "
        """
        Then I should see a response status code of "201" "Created"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "416"
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
        " { "data": [                                                           "
        "     {  "type": "subscription", "endpoint": "http://localhost:8080" }, "
        "     {  "type": "subscription", "endpoint": "http://localhost:80" }    "
        "   ]                                                                   "
        " }                                                                     "
        """

    Scenario Outline: Create empty resource.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": { } } "
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "184"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "9225118DDFD16D770600530A3E0AD4C0"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Allow" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                         "
        "     "type": "error",                                                                                                "
        "     "code": 40000,                                                                                                  "
        "     "status": 400,                                                                                                  "
        "     "title": "Bad Request",                                                                                         "
        "     "message": "The exchange is refusing to process the request because the body contains invalid property values." "
        "   }                                                                                                                 "
        " }                                                                                                                   "
        """

    Scenario Outline: Create malformed resource.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": 1."
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "159"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "8670D665E9701C41D3A3BABA9AB2ED9C"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Allow" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
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

    Scenario Outline: Create duplicate resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "218f0f04-bb57-4940-8bd9-fb81e60f8510", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "218f0f04-bb57-4940-8bd9-fb81e60f8510", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "409" "Conflict"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "179"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "D6E28FEF3810E89EFA34CE68141FD995"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Allow" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                       "
        "     "type": "error",                                                                                              "
        "     "code": 40009,                                                                                                "
        "     "status": 409,                                                                                                "
        "     "title": "Conflict",                                                                                          "
        "     "message": "The exchange is refusing to process the request because of a conflict with an existing resource." "
        "   }                                                                                                               "
        " }                                                                                                                 "
        """
