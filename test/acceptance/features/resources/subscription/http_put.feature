# language: en

Feature: HTTP PUT
    In order to modifiy a resource's current state
    As a resource owner
    I want to allow the HTTP PUT method

    Scenario Outline: Update single resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "9836e54f-73b2-46a8-9476-53001a8d8f9a", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/9836e54f-73b2-46a8-9476-53001a8d8f9a" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "endpoint": "http://localhost:80" "
        "   }                                   "
        " }                                     "
        """
        Then I should see a response status code of "200" "OK"
        And I should not see a "Location" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Last-Modified" header value
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Content-MD5" header value
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Length" header value "210"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "9836e54f-73b2-46a8-9476-53001a8d8f9a", "
        "     "endpoint": "http://localhost:80",             "
        "     "type": "subscription"                         "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Update multiple resources.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "cf42faae-7a7b-448c-9eff-f9b134acb0df", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/cf42faae-7a7b-448c-9eff-f9b134acb0df" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                           "
        "     {  "type": "subscription", "endpoint": "http://localhost:8080" }, "
        "     {  "type": "subscription", "endpoint": "http://localhost:40801" } "
        "   ]                                                                   "
        " }                                                                     "
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "192"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "88923f53298b028cbb396a492b9f40dc"
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
        " { "data": {                                                                                                                 "
        "     "type": "error",                                                                                                        "
        "     "code": 40000,                                                                                                          "
        "     "status": 400,                                                                                                          "
        "     "title": "Bad Request",                                                                                                 "
        "     "message": "The exchange is refusing to process the request because multiple resources in an update are not supported." "
        "   }                                                                                                                         "
        " }                                                                                                                           "
        """

    Scenario Outline: Update resource with no change required.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "222fba6e-7364-433c-8083-f5ea38988fe8", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/222fba6e-7364-433c-8083-f5ea38988fe8" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                             "
        "     "endpoint": "http://localhost:8080" "
        "   }                                     "
        " }                                       "
        """
        Then I should see a response status code of "204" "No Content"
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
        And I should not see a "Retry-After" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Location" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response

    Scenario Outline: Update non-existent resource.
        Given I have started a message exchange
        When I perform a HTTP "PUT" request to "/subscriptions/931fd4a1-4142-49f9-a245-dc20c068d847" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "404" "Not Found"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "197"
        And I should see a "Content-MD5" header value "8cf1a2abe9cf949d737d4aae1dd3b45c"
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
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                        "
        "     "type": "error",                                                                                                               "
        "     "code": 40004,                                                                                                                 "
        "     "status": 404,                                                                                                                 "
        "     "title": "Not Found",                                                                                                          "
        "     "message": "The exchange is refusing to process the request because the requested URI could not be found within the exchange." "
        "   }                                                                                                                                "
        " }                                                                                                                                  "
        """

    Scenario Outline: Update malformed resource.
        Given I have started a message exchange
        When I perform a HTTP "PUT" request to "/subscriptions/676ae127-318a-421b-9113-158fc24c8776" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": 1."
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "159"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "8670d665e9701c41d3a3baba9ab2ed9c"
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

    Scenario Outline: Update resource with unknown Queue key.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "key": "04fcf1a5-f88a-4d8a-82fa-e3ef6b53b5c3",       "
        "     "endpoint": "http://localhost:8080"                  "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/04fcf1a5-f88a-4d8a-82fa-e3ef6b53b5c3" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "queues": [ "39fda381-7d0a-48e2-9723-b6362f1e2a1e" ] "
        "   }                                                      "
        " }                                                        "
        """
        Then I should see a response status code of "404" "Not Found"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "207"
        And I should see a "Content-MD5" header value "633ff088f4b7425851f4150b5cd8f41a"
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
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                                  "
        "     "type": "error",                                                                                                                         "
        "     "code": 40004,                                                                                                                           "
        "     "status": 404,                                                                                                                           "
        "     "title": "Not Found",                                                                                                                    "
        "     "message": "The exchange is refusing to process the request because one or more subscription queues property values could not be found." "
        "   }                                                                                                                                          "
        " }                                                                                                                                            "
        """

    Scenario Outline: Update resource with malformed endpoint.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "key": "04fcf1a5-f88a-4d8a-82fa-e3ef6b53b5c3",       "
        "     "endpoint": "http://localhost:8080"                  "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/04fcf1a5-f88a-4d8a-82fa-e3ef6b53b5c3" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {              "
        "     "endpoint": "haagen" "
        "   }                      "
        " }                        "
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "184"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-MD5" header value "9225118ddfd16d770600530a3e0ad4c0"
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
