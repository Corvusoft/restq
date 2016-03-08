# language: en

Feature: Reserved words
    In order to keep a selection of fields for internal exchange usage
    As an exchange developer
    I want to ignore certain keywords in resource definitions

    Scenario Outline: Create containing reserved keywords.
        Given I have started a message exchange
        When I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                "
        "     "type": "apple",                       "
        "     "origin": "fe80::908d:9aff:fe40:9974", "
        "     "created": 1455640164,                 "
        "     "modified": 1455640164                 "
        "   }                                        "
        " }                                          "
        """
        Then I should see a response status code of "201" "Created"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "170"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Location" header value
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
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "type": "queue"                                "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Update with change required containing reserved keywords.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                       "
        "     "key": "13b20e52-9af1-43dc-839b-3d8ffb45a57b" "
        "   }                                               "
        " }                                                 "
        """
        When I perform a HTTP "PUT" request to "/queues/13b20e52-9af1-43dc-839b-3d8ffb45a57b" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
         """
        " { "data": {                                        "
        "     "type": "pear",                                "
        "     "key": "d94be181-9d73-422a-8d37-6f5bca0ead3b", "
        "     "origin": "fe80::908d:9aff:fe40:9974",         "
        "     "created": 1455640164,                         "
        "     "modified": 1455640164,                        "
        "     "data-to-trigger-change": "data"               "
        "   }                                                "
        " }                                                  "
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
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Last-Modified" header value
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Content-MD5" header value
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Length" header value "202"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "type": "queue",                               "
        "     "key": "13b20e52-9af1-43dc-839b-3d8ffb45a57b", "
        "     "data-to-trigger-change": "data"               "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Update with no change required containing reserved keywords.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                       "
        "     "key": "3cb785ec-5709-452c-9241-c900e467ce12" "
        "   }                                               "
        " }                                                 "
        """
        When I perform a HTTP "PUT" request to "/queues/3cb785ec-5709-452c-9241-c900e467ce12" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
         """
        " { "data": {                                        "
        "     "type": "pear",                                "
        "     "key": "b02b4129-2f54-428b-a4ff-6b1fae7daac7", "
        "     "origin": "fe80::908d:9aff:fe40:9974",         "
        "     "created": 1455640164,                         "
        "     "modified": 1455640164                         "
        "   }                                                "
        " }                                                  "
        """
        Then I should see a response status code of "204" "No Content"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Last-Modified" header value
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
