# language: en

Feature: Content-Length entity-header field
    In order to interpret the response body
    As a resource owner
    I want a resource that includes the Content-Length entity-header field

    Scenario Outline: Valid content-length field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "417c6444-6050-46ec-9329-60fd5e31a44d", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/417c6444-6050-46ec-9329-60fd5e31a44d" with headers "Content-Type: application/json, Accept: application/json, Content-Length: 156, Host: localhost:1984":
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
        "     "key": "417c6444-6050-46ec-9329-60fd5e31a44d", "
        "     "name": "renamed-acceptance-test",             "
        "     "type": "queue"                                "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Invalid content-length field; too small.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "a0c329e6-7662-4625-9be0-0344e24c8d75", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/a0c329e6-7662-4625-9be0-0344e24c8d75" with headers "Content-Type: application/json, Accept: application/json, Content-Length: 3, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "e867b0ce-4e6f-4169-973d-fe1d173eaaf0", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/e867b0ce-4e6f-4169-973d-fe1d173eaaf0" with headers "Content-Type: application/json, Accept: application/json, Content-Length: 98700, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
        """
        Then I should see the exchange shutdown the connection after 5 seconds

    Scenario Outline: Abscent content-length field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "637e17c8-fa79-4652-89e0-b00ddd34f4b3", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/637e17c8-fa79-4652-89e0-b00ddd34f4b3" with only headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "ae33df87-bdce-4355-8112-6bf3f415fa51", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/ae33df87-bdce-4355-8112-6bf3f415fa51" with headers "Content-Type: application/json, Accept: application/json, Content-Length: 0, Host: localhost:1984":
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "4c0809db-e950-413a-93da-e01302479df0", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/4c0809db-e950-413a-93da-e01302479df0" with headers "Content-Type: application/json, Accept: application/json, Content-Length: , Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "364c13cc-91f1-4f9e-b478-36963fae91de", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/364c13cc-91f1-4f9e-b478-36963fae91de" with headers "Content-Type: application/json, Accept: application/json, Content-Length: lkajfw098, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
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
