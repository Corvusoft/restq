# language: en

Feature: End-to-end HTTP message delivery
    In order to deliver messages in a common protocol
    As an exchange consumer/producer
    I want to support HTTP message delivery

    Scenario Outline: Route HTTP message.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "tags": [ "http", "msgs", "test" ],            "
        "     "key": "8ae01437-ef03-40ad-b172-c927209686fb"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "8ae01437-ef03-40ad-b172-c927209686fb" ] "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "POST" request to "/queues/8ae01437-ef03-40ad-b172-c927209686fb/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Hello, World! "
        """
        And I wait "5" seconds
        Then I should see a message arrive at "http://localhost:1985":
        """
        " Hello, World! "
        """
        And I should see a message "Connection" header value "close"
        And I should see a message "Date" header value
        And I should see a message "Expires" header value "0"
        And I should see a message "Pragma" header value "no-cache"
        And I should see a message "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a message "Content-Type" header value "text/plain"
        And I should see a message "Content-Length" header value "15"
        And I should see a message "Content-MD5" header value "cdfd4c824484b345c35b372963060b83"
        And I should see a message "Last-Modified" header value
        And I should see a message "Via" header value "HTTP/1.1 localhost:1984"
        And I should see a message "From" header value "not implemented"
        And I should see a message "Referer" header value
        And I should see an empty response
