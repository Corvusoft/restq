# language: en

Feature: Accept request-header field
    In order to specify an acceptable media type for the response
    As a resource owner
    I want a resource that processes the Accept request-header field

    Scenario Outline: Valid accept field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "aa4e8e34-7d77-49f9-a33d-02f0368ffc23", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/subscriptions/aa4e8e34-7d77-49f9-a33d-02f0368ffc23" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "232"
        And I should see a "Connection" header value "close"
        And I should see a "Content-MD5" header value
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Allow" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "aa4e8e34-7d77-49f9-a33d-02f0368ffc23", "
        "     "type": "subscription",                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Invalid accept field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "2ed5c55d-c2ba-4027-85a7-04fd11d6cc07", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/subscriptions/2ed5c55d-c2ba-4027-85a7-04fd11d6cc07" with header "Accept: application/bson, Host: localhost:1984"
        Then I should see a response status code of "406" "Not Acceptable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "text/plain; charset=utf-8"
        And I should see a "Content-Length" header value "162"
        And I should see a "Content-MD5" header value "abdf0cb26fa034c5c1b2ad112a7e3b53"
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
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
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
        And I should see the response message:
        """
        "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept header sent in the request."
        """

    Scenario Outline: Abscent accept field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "819fc37e-3f03-4f51-924a-0f8d216c25b2", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/subscriptions/819fc37e-3f03-4f51-924a-0f8d216c25b2" with header "Host: localhost:1984"
        Then I should see a response status code of "406" "Not Acceptable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "text/plain; charset=utf-8"
        And I should see a "Content-Length" header value "162"
        And I should see a "Content-MD5" header value "abdf0cb26fa034c5c1b2ad112a7e3b53"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
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
        And I should see the response message:
        """
        "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept header sent in the request."
        """

    Scenario Outline: Empty accept field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "53c0ab62-4aad-49a7-a6b1-47872b029ced", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/subscriptions/53c0ab62-4aad-49a7-a6b1-47872b029ced" with headers "Accept: , Host: localhost:1984"
        Then I should see a response status code of "406" "Not Acceptable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "text/plain; charset=utf-8"
        And I should see a "Content-Length" header value "162"
        And I should see a "Content-MD5" header value "abdf0cb26fa034c5c1b2ad112a7e3b53"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
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
        And I should see the response message:
        """
        "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept header sent in the request."
        """

    Scenario Outline: Wildcard accept field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "aa4e8e34-7d77-49f9-a33d-02f0368ffc23", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/subscriptions/aa4e8e34-7d77-49f9-a33d-02f0368ffc23" with headers "Accept: */*, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "232"
        And I should see a "Content-MD5" header value
        And I should see a "Date" header value
        And I should see a "Connection" header value "close"
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Location" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "aa4e8e34-7d77-49f9-a33d-02f0368ffc23", "
        "     "type": "subscription",                        "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
