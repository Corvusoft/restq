# language: en

Feature: Content-Type entity-header field
    In order to interpret the response body
    As a resource owner
    I want a resource that includes the Content-Type entity-header field

    Scenario Outline: Valid content-type field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "8404c029-f184-4fd9-a0f8-52a02779f622", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/8404c029-f184-4fd9-a0f8-52a02779f622" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
        """
        Then I should see a response status code of "200" "OK"
        And I should not see a "Age" header value
        And I should not see a "Location" header value
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
        And I should see a "Content-Length" header value "203"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "8404c029-f184-4fd9-a0f8-52a02779f622", "
        "     "name": "renamed-acceptance-test",             "
        "     "type": "queue"                                "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Invalid content-type field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "e92fd26f-9d83-418f-a03f-208002643be4", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/e92fd26f-9d83-418f-a03f-208002643be4" with headers "Content-Type: application/xml, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
        """
        Then I should see a response status code of "415" "Unsupported Media Type"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "263"
        And I should see a "Content-MD5" header value "E9A707D20D6F46F9FCE963575206D224"
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
        "     "code": 40015,                                                                                                                                                                           "
        "     "status": 415,                                                                                                                                                                           "
        "     "title": "Unsupported Media Type",                                                                                                                                                       "
        "     "message": "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request."      "
        "   }                                                                                                                                                                                          "
        " }                                                                                                                                                                                            "
        """

    Scenario Outline: Abscent content-type field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "68f399ba-adb0-4834-82f9-62f9b282f18f", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/68f399ba-adb0-4834-82f9-62f9b282f18f" with headers "Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
        """
        Then I should see a response status code of "415" "Unsupported Media Type"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "263"
        And I should see a "Content-MD5" header value "E9A707D20D6F46F9FCE963575206D224"
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
        "     "code": 40015,                                                                                                                                                                           "
        "     "status": 415,                                                                                                                                                                           "
        "     "title": "Unsupported Media Type",                                                                                                                                                       "
        "     "message": "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request."      "
        "   }                                                                                                                                                                                          "
        " }                                                                                                                                                                                            "
        """

    Scenario Outline: Empty content-type field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "4ef6c657-748f-40f4-9e07-99a5bb642111", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/4ef6c657-748f-40f4-9e07-99a5bb642111" with headers "Content-Type: , Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
        """
        Then I should see a response status code of "415" "Unsupported Media Type"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "263"
        And I should see a "Content-MD5" header value "E9A707D20D6F46F9FCE963575206D224"
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
        "     "code": 40015,                                                                                                                                                                           "
        "     "status": 415,                                                                                                                                                                           "
        "     "title": "Unsupported Media Type",                                                                                                                                                       "
        "     "message": "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request."      "
        "   }                                                                                                                                                                                          "
        " }                                                                                                                                                                                            "
        """
