# language: en

Feature: Content-Type entity-header field
    In order to interpret the response body
    As a collection owner
    I want a collection that includes the Content-Type entity-header field

    Scenario Outline: Valid content-type field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "201" "Created"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "336"
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

    Scenario Outline: Invalid content-type field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/xml, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "415" "Unsupported Media Type"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "263"
        And I should see a "Content-MD5" header value "e9a707d20d6f46f9fce963575206d224"
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
        When I perform a HTTP "POST" request to "/queues" with headers "Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "415" "Unsupported Media Type"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "263"
        And I should see a "Content-MD5" header value "e9a707d20d6f46f9fce963575206d224"
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
        When I perform a HTTP "POST" request to "/queues" with headers "Content-Type: , Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "415" "Unsupported Media Type"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "263"
        And I should see a "Content-MD5" header value "e9a707d20d6f46f9fce963575206d224"
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
