# language: en

Feature: Accept request-header field
    In order to specify an acceptable media type for the response
    As a resource owner
    I want a resource that processes the Accept request-header field

    Scenario Outline: Valid accept field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "813df7ee-3582-4f17-9d77-0f7abb965075"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "813df7ee-3582-4f17-9d77-0f7abb965075" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low."
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Allow" header value "OPTIONS"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Location" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response

    Scenario Outline: Invalid accept field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "fb8005a7-5b0b-4044-88d4-b6a7ba2d02b9"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "fb8005a7-5b0b-4044-88d4-b6a7ba2d02b9" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low."
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: application/bson, Host: localhost:1984"
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "9c4193f0-dd10-4c0c-9ea9-b647d9654fb8"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "9c4193f0-dd10-4c0c-9ea9-b647d9654fb8" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low."
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with header "Host: localhost:1984"
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "3e68ed03-38b3-497d-85d7-f578b9c1ca92"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "3e68ed03-38b3-497d-85d7-f578b9c1ca92" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low."
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: , Host: localhost:1984"
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "4833ff51-5891-42dc-ac73-8b17d1dcd035"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "4833ff51-5891-42dc-ac73-8b17d1dcd035" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Water level low."
        """
        When I perform a HTTP "OPTIONS" request to the last response "Location" header value with headers "Accept: */*, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Allow" header value "OPTIONS"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Location" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response
