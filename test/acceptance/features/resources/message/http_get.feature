# language: en

Feature: HTTP GET
    In order to restrict the HTTP methods available
    As a collection owner
    I want to disallow the HTTP GET method

    Scenario Outline: Read resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "71829c94-e112-4766-9a57-35b330ec41c0"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "71829c94-e112-4766-9a57-35b330ec41c0" ] "
        "   }                                                      "
        " } 
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/xml, Accept: application/json, Host: localhost:1984":
        """
        " Important event"
        """
        When I perform a HTTP "GET" request to the last response "Location" header value with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "405" "Method Not Allowed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "203"
        And I should see a "Content-MD5" header value "D79174F3477FCB685EB896ACDFD5FBE4"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Allow" header value "OPTIONS"
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
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                     "
        "     "type": "error",                                                                                                            "
        "     "code": 40005,                                                                                                              "
        "     "status": 405,                                                                                                              "
        "     "title": "Method Not Allowed",                                                                                              "
        "     "message": "The exchange is refusing to process the request because the requested method is not allowed for this resource." "
        "   }                                                                                                                             "
        " }                                                                                                                               "
        """

    Scenario Outline: Read non-existent resource.
        Given I have started a message exchange
        When I perform a HTTP "GET" request to "/messages/2b1456f3-0d64-4823-9922-923b655e22fe" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "405" "Method Not Allowed"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "203"
        And I should see a "Content-MD5" header value "D79174F3477FCB685EB896ACDFD5FBE4"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Allow" header value "OPTIONS"
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
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                     "
        "     "type": "error",                                                                                                            "
        "     "code": 40005,                                                                                                              "
        "     "status": 405,                                                                                                              "
        "     "title": "Method Not Allowed",                                                                                              "
        "     "message": "The exchange is refusing to process the request because the requested method is not allowed for this resource." "
        "   }                                                                                                                             "
        " }                                                                                                                               "
        """
