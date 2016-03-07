# language: en

Feature: Expect request-header field
    In order to indicate that particular server behaviors are required by the client
    As a collection owner
    I want a collection that responds correctly to Expect request-header fields

    Scenario Outline: Valid expect request-header field.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Expect: 100-continue, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "417" "Expectation Failed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "193"
        And I should see a "Content-MD5" header value "DA27569D32B5D6F7B8F7950DEA05995F"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
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
        When I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Expect: %^&*&!@(]^%$, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "417" "Expectation Failed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "193"
        And I should see a "Content-MD5" header value "DA27569D32B5D6F7B8F7950DEA05995F"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
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
        When I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Expect: , Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "417" "Expectation Failed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "193"
        And I should see a "Content-MD5" header value "DA27569D32B5D6F7B8F7950DEA05995F"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
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
        