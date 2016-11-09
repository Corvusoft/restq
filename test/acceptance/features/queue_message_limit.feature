# language: en

Feature: Queue Message Limit
    In order to restrict the maximum allowed number of messages on a queue
    As a Queue owner
    I want support for limiting a queue's message capacity
@wip
    Scenario Outline: Exceed message limit.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "17e0ef35-e154-4f7e-ac1d-acd534002819", "
        "     "message-limit": 2                             "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://unreachable",                    "
        "     "queues": [ "17e0ef35-e154-4f7e-ac1d-acd534002819" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/queues/17e0ef35-e154-4f7e-ac1d-acd534002819/messages" with headers "Content-Length: 178, Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Many years ago, a hunter brought a private supply of this exceptional barrel-aged bourbon, on a Wild Turkey hunt, earning its name that is now the benchmark of quailty bourbon. "
        """
        And I should see a response status code of "202" "Accepted"
        And I perform a HTTP "POST" request to "/queues/17e0ef35-e154-4f7e-ac1d-acd534002819/messages" with headers "Content-Length: 364, Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Safe from the reach of the law, George Connell begins distilling in secret at Burnfoot Farm - where you'll find today's Glengoyne Distillery. The hidden waterfall and its miniature glen make it easy for George to escape the notice of the Exciseman. He's not the first to distil here illegally - it's reckoned George learned the stillman's art from his grandfather. "
        """
        And I should see a response status code of "202" "Accepted"
        When I perform a HTTP "POST" request to "/queues/17e0ef35-e154-4f7e-ac1d-acd534002819/messages" with headers "Content-Length: 22, Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Yikes! One too many. "
        """
        Then I should see a response status code of "503" "Service Unavailable"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "194"
        And I should see a "Content-MD5" header value "77b7662c988d97c30eeaccea927834d2"
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
        " { "data": {                                                                                                                      "
        "     "type": "error",                                                                                                             "
        "     "code": 50003,                                                                                                               "
        "     "status": 503,                                                                                                               "
        "     "title": "Service Unavailable",                                                                                              "
        "     "message": "The exchange is refusing to process a request because the message would violate a queue(s) capacity."            "
        "   }                                                                                                                              "
        " }                                                                                                                                "
        """
