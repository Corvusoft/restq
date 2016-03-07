# language: en

Feature: Expect request-header field
    In order to indicate that particular server behaviors are required by the client
    As a exchange developer
    I want a resource that responds to the Expect request-header field

    Scenario Outline: Valid expect request-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "46bd2666-7e8f-439c-b44d-232e7ce8f3f9", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/queues/46bd2666-7e8f-439c-b44d-232e7ce8f3f9" with headers "Accept: application/json, Host: localhost:1984, Expect: 100-continue"
        Then I should see a response status code of "417" "Expectation Failed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "193"
        And I should see a "Content-MD5" header value "DA27569D32B5D6F7B8F7950DEA05995F"
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
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
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
        " { "data": {                                                                                                           "
        "     "type": "error",                                                                                                  "
        "     "code": 40017,                                                                                                    "
        "     "status": 417,                                                                                                    "
        "     "title": "Expectation Failed",                                                                                    "
        "     "message": "The exchange is refusing to process the request because a request expectation failed; not supported." "
        "   }                                                                                                                   "
        " }                                                                                                                     "
        """

    Scenario Outline: Invalid expect request-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "ee31ecad-7c32-4561-af0a-c49aeac175db", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/queues/ee31ecad-7c32-4561-af0a-c49aeac175db" with headers "Accept: application/json, Host: localhost:1984, Expect: %^&*&!@(]^%$"
        Then I should see a response status code of "417" "Expectation Failed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "193"
        And I should see a "Content-MD5" header value "DA27569D32B5D6F7B8F7950DEA05995F"
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
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
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
        " { "data": {                                                                                                           "
        "     "type": "error",                                                                                                  "
        "     "code": 40017,                                                                                                    "
        "     "status": 417,                                                                                                    "
        "     "title": "Expectation Failed",                                                                                    "
        "     "message": "The exchange is refusing to process the request because a request expectation failed; not supported." "
        "   }                                                                                                                   "
        " }                                                                                                                     "
        """

    Scenario Outline: Empty expect request-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "e0f2a259-88cf-49bc-bc19-839fa874793a", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/queues/e0f2a259-88cf-49bc-bc19-839fa874793a" with headers "Accept: application/json, Host: localhost:1984, Expect: "
        Then I should see a response status code of "417" "Expectation Failed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "193"
        And I should see a "Content-MD5" header value "DA27569D32B5D6F7B8F7950DEA05995F"
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
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
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
        " { "data": {                                                                                                           "
        "     "type": "error",                                                                                                  "
        "     "code": 40017,                                                                                                    "
        "     "status": 417,                                                                                                    "
        "     "title": "Expectation Failed",                                                                                    "
        "     "message": "The exchange is refusing to process the request because a request expectation failed; not supported." "
        "   }                                                                                                                   "
        " }                                                                                                                     "
        """
