# language: en

Feature: Message multiplexing
    In order to deliver messages to multiple queues
    As an exchange message producer
    I want to support message multiplexing

    Scenario Outline: Multiplex message by queue properties
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "queue 1",                             "
        "     "tag": "weather",                              "
        "     "key": "c1dcd073-b9af-4e09-a8b9-1f052b962111"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "queue 2",                             "
        "     "tag": "weather",                              "
        "     "key": "e929e8f8-2e71-4eac-9858-0f6c3e82bad8"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "queue 2 consumer",                          "
        "     "endpoint": "http://localhost:1985?index=0",         "
        "     "queues": [ "e929e8f8-2e71-4eac-9858-0f6c3e82bad8" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "queue 1 consumer",                          "
        "     "endpoint": "http://localhost:1985?index=1",         "
        "     "queues": [ "c1dcd073-b9af-4e09-a8b9-1f052b962111" ] "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "POST" request to "/messages?tag=weather" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Wind Speed 5 knots, NE Direction "
        """
        And I wait "5" seconds
        Then I should see a message arrive at "http://localhost:1985?index=0":
        """
        " Wind Speed 5 knots, NE Direction "
        """
        And I should see a message "Connection" header value "close"
        And I should see a message "Date" header value
        And I should see a message "Expires" header value "0"
        And I should see a message "Pragma" header value "no-cache"
        And I should see a message "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a message "Content-Type" header value "text/plain"
        And I should see a message "Content-Length" header value "34"
        And I should see a message "Content-MD5" header value "98715e57f4de5798c61fc7585970c3a4"
        And I should see a message "Last-Modified" header value
        And I should see a message "Via" header value "HTTP/1.1 localhost:1984"
        And I should see a message "From" header value "not implemented"
        And I should see a message "Referer" header value
        And I should see an empty response
        And I should see a message arrive at "http://localhost:1985?index=1":
        """
        " Wind Speed 5 knots, NE Direction "
        """
        And I should see a message "Connection" header value "close"
        And I should see a message "Date" header value
        And I should see a message "Expires" header value "0"
        And I should see a message "Pragma" header value "no-cache"
        And I should see a message "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a message "Content-Type" header value "text/plain"
        And I should see a message "Content-Length" header value "34"
        And I should see a message "Content-MD5" header value "98715e57f4de5798c61fc7585970c3a4"
        And I should see a message "Last-Modified" header value
        And I should see a message "Via" header value "HTTP/1.1 localhost:1984"
        And I should see a message "From" header value "not implemented"
        And I should see a message "Referer" header value
        And I should see an empty response

    Scenario Outline: Multiplex message by queue keys
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "queue 1",                             "
        "     "tag": "weather",                              "
        "     "key": "48f80e83-3c56-4897-992d-c38ed6a0e3b6"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "queue 2",                             "
        "     "tag": "weather",                              "
        "     "key": "67745d9e-82a4-4754-9cdf-9012ef5d33b3"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "queue 2 consumer",                          "
        "     "endpoint": "http://localhost:1985?index=0",         "
        "     "queues": [ "48f80e83-3c56-4897-992d-c38ed6a0e3b6" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "queue 1 consumer",                          "
        "     "endpoint": "http://localhost:1985?index=1",         "
        "     "queues": [ "67745d9e-82a4-4754-9cdf-9012ef5d33b3" ] "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "POST" request to "/messages?keys=67745d9e-82a4-4754-9cdf-9012ef5d33b3,48f80e83-3c56-4897-992d-c38ed6a0e3b6" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Wind Speed 5 knots, NE Direction "
        """
        And I wait "5" seconds
        Then I should see a message arrive at "http://localhost:1985?index=0":
        """
        " Wind Speed 5 knots, NE Direction "
        """
        And I should see a message "Connection" header value "close"
        And I should see a message "Date" header value
        And I should see a message "Expires" header value "0"
        And I should see a message "Pragma" header value "no-cache"
        And I should see a message "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a message "Content-Type" header value "text/plain"
        And I should see a message "Content-Length" header value "34"
        And I should see a message "Content-MD5" header value "98715e57f4de5798c61fc7585970c3a4"
        And I should see a message "Last-Modified" header value
        And I should see a message "Via" header value "HTTP/1.1 localhost:1984"
        And I should see a message "From" header value "not implemented"
        And I should see a message "Referer" header value
        And I should see an empty response
        And I should see a message arrive at "http://localhost:1985?index=1":
        """
        " Wind Speed 5 knots, NE Direction "
        """
        And I should see a message "Connection" header value "close"
        And I should see a message "Date" header value
        And I should see a message "Expires" header value "0"
        And I should see a message "Pragma" header value "no-cache"
        And I should see a message "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a message "Content-Type" header value "text/plain"
        And I should see a message "Content-Length" header value "34"
        And I should see a message "Content-MD5" header value "98715e57f4de5798c61fc7585970c3a4"
        And I should see a message "Last-Modified" header value
        And I should see a message "Via" header value "HTTP/1.1 localhost:1984"
        And I should see a message "From" header value "not implemented"
        And I should see a message "Referer" header value
        And I should see an empty response
