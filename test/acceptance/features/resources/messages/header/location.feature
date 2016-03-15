# language: en

Feature: Location response-header field
    In order to inform a recipient of the identification of a new resource
    As a collection owner
    I want the Location response-header returned for newly created resources

    Scenario Outline: Create message.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "fb060c2b-3317-473d-a5d9-1d3bc8e42e9d"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "fb060c2b-3317-473d-a5d9-1d3bc8e42e9d" ] "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " ftp://localhost/reading "
        """
        Then I should see a response status code of "202" "Accepted"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Allow" header value "OPTIONS"
        And I should see a "Location" header value
        And I should not see a "ETag" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Last-Modified" header value
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
        And I should see an empty response

    Scenario Outline: Create message with no queues.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " ftp://localhost/reading "
        """
        Then I should see a response status code of "201" "Created"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should see a "Accept-Ranges" header value "none"
        And I should not see a "Allow" header value
        And I should not see a "Location" header value
        And I should not see a "ETag" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Last-Modified" header value
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
        And I should see an empty response
