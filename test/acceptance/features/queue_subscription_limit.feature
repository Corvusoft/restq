# language: en

Feature: Queue Subscription Limit
    In order to restrict the maximum allowed number of subscriptions to a queue
    As a Queue owner
    I want support for limiting a queue's subscription capacity

    Scenario Outline: Exceed subscription limit.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "c560c074-2566-43d0-8ffd-001e9f53db2b", "
        "     "subscription-limit": 2                        "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer 1",                "
        "     "endpoint": "http://unreachable",                    "
        "     "queues": [ "c560c074-2566-43d0-8ffd-001e9f53db2b" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I should see a response status code of "201" "Created"
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer 2",                "
        "     "endpoint": "http://unreachable",                    "
        "     "queues": [ "c560c074-2566-43d0-8ffd-001e9f53db2b" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I should see a response status code of "201" "Created"
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer 3",                "
        "     "endpoint": "http://unreachable",                    "
        "     "queues": [ "c560c074-2566-43d0-8ffd-001e9f53db2b" ] "
        "   }                                                      "
        " }                                                        "
        """
        Then I should see a response status code of "503" "Service Unavailable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "214"
        And I should see a "Content-MD5" header value "6d1e38c86b4369ef7f0260d1f3216e20"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Allow" header value
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
        " { "data": {                                                                                                                               "
        "     "type": "error",                                                                                                                      "
        "     "code": 50003,                                                                                                                        "
        "     "status": 503,                                                                                                                        "
        "     "title": "Service Unavailable",                                                                                                       "
        "     "message": "The exchange is refusing to process a request because a new subscription would violate a queue(s) subscription capacity." "
        "   }                                                                                                                                       "
        " }                                                                                                                                         "
        """
