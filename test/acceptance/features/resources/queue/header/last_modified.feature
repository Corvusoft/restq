# language: en

Feature: Last-Modified entity-header field
    In order to identify the last alteration made to a resource
    As a resource owner
    I want a resource that returns the Last-Modified entity-header field

    Scenario Outline: Update resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "24517b76-c91e-40c0-a5b7-d167c6b6c420", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        And I wait "10" seconds
        When I perform a HTTP "PUT" request to "/queues/24517b76-c91e-40c0-a5b7-d167c6b6c420" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                           "
        "     "name": "renamed-acceptance-test" "
        "   }                                   "
        " }                                     "
        """
        Then I should see a response status code of "200" "OK"
        And I should not see a "Location" header value
        And I should not see a "Age" header value
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
        And I should see a "Last-Modified" header value with a datestamp of now plus "10"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
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
        "     "key": "24517b76-c91e-40c0-a5b7-d167c6b6c420", "
        "     "name": "renamed-acceptance-test",             "
        "     "type": "queue"                                "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Update resource with no change required.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "4b570eb4-bc1c-4be6-b9a5-cc038ce0f5bf", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        And I wait "10" seconds
        When I perform a HTTP "PUT" request to "/queues/4b570eb4-bc1c-4be6-b9a5-cc038ce0f5bf" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                   "
        "     "name": "acceptance-test" "
        "   }                           "
        " }                             "
        """
        Then I should see a response status code of "204" "No Content"
        And I should see a "Last-Modified" header value with a datestamp of now minus "10"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Allow" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Location" header value
        And I should not see a "Content-MD5" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Length" header value
        And I should not see a "Content-Type" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see an empty response
