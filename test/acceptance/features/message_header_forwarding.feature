# language: en

Feature: HTTP header forwarding
    In order to decorate a message with additional meta-data
    As an exchange message producer
    I want to support HTTP header forwarding to the consumer

    Scenario Outline: Header forwarding.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "30a2f43f-1d54-4e7b-9ca5-60c809eeff86"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "30a2f43f-1d54-4e7b-9ca5-60c809eeff86" ] "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "POST" request to "/queues/30a2f43f-1d54-4e7b-9ca5-60c809eeff86/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984, My-Custom-Header: apples are not oranges, Device: Grid Unit xa37b":
        """
        " Hello, World! "
        """
        And I wait "5" seconds
        Then I should see a message arrive at "http://localhost:1985":
        """
        " Hello, World! "
        """
        And I should see a message "Device" header value "Grid Unit xa37b"
        And I should see a message "My-Custom-Header" header value "apples are not oranges"
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
