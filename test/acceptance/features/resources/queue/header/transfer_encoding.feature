# language: en

Feature: Transfer-Encoding general-header field
    In order to ignore transfer-encoding requests 
    As a exchange developer
    I want to return a normal status for the Transfer-Encoding general-header field.

    Scenario Outline: Presense of transfer-encoding general-header field with content-length.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "651aa216-e9f2-48c8-b358-4515ec50514d", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/651aa216-e9f2-48c8-b358-4515ec50514d" with headers "Content-Type: application/json, Accept: application/json, Content-Length: 156, Host: localhost:1984, Transfer-Encoding: chunked":
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
        And I should see a "Content-Length" header value "273"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "651aa216-e9f2-48c8-b358-4515ec50514d", "
        "     "name": "renamed-acceptance-test",             "
        "     "type": "queue"                                "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Presense of transfer-encoding general-header field without content-length.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "7b35fe20-7f7e-4ebd-93ae-6186934f1443", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/queues/7b35fe20-7f7e-4ebd-93ae-6186934f1443" with only headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Transfer-Encoding: chunked":
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
        And I should see a "Content-MD5" header value "91fb953c1cd977119e980541b598a4c0"
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
