# language: en

Feature: Message Delivery Circuit Breaker
    In order to restrict endlessly (re)delivering messages to unreachable consumers
    As a Queue owner
    I want to support deactivating consumer subscriptions

    @manual
    Scenario Outline: Attempt 2 deliveries with an interval of 10 seconds before deactiving consumer subscription.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "redelivery-interval": 10,                     "
        "     "max-delivery-attempts": 2,                    "
        "     "key": "ad556490-4e31-421e-adec-4b3e003476f2"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "state": "reachable",                                "
        "     "endpoint": "http://unreachable",                    "
        "     "queues": [ "ad556490-4e31-421e-adec-4b3e003476f2" ] "
        "   }                                                      "
        " }                                                        "
        """
        When I perform a HTTP "POST" request to "/queues/ad556490-4e31-421e-adec-4b3e003476f2/messages" with headers "Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Hello, World! "
        """
        Then I should see a response status code of "202" "Accepted"
        And I should see a failed message delivery attempt
        And I wait "10" seconds
        And I should see a failed message delivery attempt
        And I should see the subscription state set to "unreachable"
        And I should see no further message delivery attempt to the subscription

    @manual
    Scenario Outline: Reactive Subscription.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "redelivery-interval": 10,                     "
        "     "max-delivery-attempts": 2,                    "
        "     "key": "a2615481-66d7-4638-96f5-70151770a41b"  "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                              "
        "     "state": "reachable",                                "
        "     "endpoint": "http://unreachable",                    "
        "     "key": "7cd5f187-01dd-4a24-9030-d0d0e795a8c5",       "
        "     "queues": [ "a2615481-66d7-4638-96f5-70151770a41b" ] "
        "   }                                                      "
        " }                                                        "
        """
        And I trip the message delivery circuit breaker
        When I perform a HTTP "PUT" request to "/subscriptions/7cd5f187-01dd-4a24-9030-d0d0e795a8c5" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {              "
        "     "state": "reachable" "
        "   }                      "
        " }                        "
        """
        Then I should see a response status code of "200" "OK"
        And I should see the consumer's subscription reactivated
