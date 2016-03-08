# language: en

Feature: If-Unmodified-Since request-header field
    In order to ignore conditional requests 
    As a exchange developer
    I want to return a normal status for the If-Unmodified-Since request-header field

    Scenario Outline: Date if-unmodified-since request-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "ce7a8b33-f4ed-41c5-842d-f58057a5d112", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "HEAD" request to "/subscriptions/ce7a8b33-f4ed-41c5-842d-f58057a5d112" with headers "Accept: application/json, Host: localhost:1984, If-Unmodified-Since: Sat, 29 Oct 1994 19:43:31 GMT"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "212"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
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
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response

    Scenario Outline: Malformed if-unmodified-since request-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "5af60ed0-f8c0-4381-9a82-f767216225e8", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "HEAD" request to "/subscriptions/5af60ed0-f8c0-4381-9a82-f767216225e8" with headers "Accept: application/json, Host: localhost:1984, If-Unmodified-Since: 3u9c8duco"
        Then I should see a response status code of "204" "No Content"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "212"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
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
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response

    Scenario Outline: Empty if-unmodified-since request-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "9666f2bb-bc2a-456b-9999-cd44e47f9e2e", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "HEAD" request to "/subscriptions/9666f2bb-bc2a-456b-9999-cd44e47f9e2e" with headers "Accept: application/json, Host: localhost:1984, If-Unmodified-Since: "
        Then I should see a response status code of "204" "No Content"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "212"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
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
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response
