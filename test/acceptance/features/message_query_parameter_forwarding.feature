# language: en

Feature: HTTP query parameter forwarding
    In order to decorate a message with additional meta-data
    As an exchange message producer
    I want to support HTTP query parameter forwarding to the consumer

    Scenario Outline: Query forwarding.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "8beaad29-da53-4164-b543-2a1e42780a5b"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "name": "acceptance test consumer",                  "
        "     "endpoint": "http://localhost:1985",                 "
        "     "queues": [ "8beaad29-da53-4164-b543-2a1e42780a5b" ] "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "POST" request to "/queues/8beaad29-da53-4164-b543-2a1e42780a5b/messages?shutdown=20mins&reboot=true" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Hello, World! "
        """
        And I wait "5" seconds
        Then I should see a message arrive at "http://localhost:1985":
        """
        " Hello, World! "
        """
        And I should see a message "reboot" query parameter value "true"
        And I should see a message "shutdown" query parameter value "20mins"
        And I should see a message "Connection" header value "close"
        And I should see a message "Date" header value
        And I should see a message "Expires" header value "0"
        And I should see a message "Pragma" header value "no-cache"
        And I should see a message "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a message "Content-Type" header value "text/plain"
        And I should see a message "Content-Length" header value "15"
        And I should see a message "Content-MD5" header value "CDFD4C824484B345C35B372963060B83"
        And I should see a message "Last-Modified" header value
        And I should see a message "Via" header value "HTTP/1.1 localhost:1984"
        And I should see a message "From" header value "not implemented"
        And I should see a message "Referer" header value
        And I should see an empty response
