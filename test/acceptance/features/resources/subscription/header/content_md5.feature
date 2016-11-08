# language: en

Feature: Content-MD5 entity-header field
    In order to provide end-to-end entity-body integrity validation
    As a resource consumer
    I want to support message integrity checking (MIC) via MD5 checksums

    Scenario Outline: Valid uppercase content-md5 entity-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "3182ea11-54f6-45d2-a792-e3b4560a024e", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/3182ea11-54f6-45d2-a792-e3b4560a024e" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-MD5: 2D7E5F4AC3676AFE661C255EF96D803F":
        """
        " { "data": {                           "
        "     "endpoint": "http://localhost:80" "
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
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Last-Modified" header value
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Content-MD5" header value
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Length" header value "230"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "3182ea11-54f6-45d2-a792-e3b4560a024e", "
        "     "endpoint": "http://localhost:80",             "
        "     "type": "subscription"                         "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Valid lowercase content-md5 entity-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "597d2ea7-f71f-414d-83f2-971428bfb268", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/597d2ea7-f71f-414d-83f2-971428bfb268" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-MD5: 90cdc08b1300e283499a0872cc722a25":
        """
        " { "data": {                           "
        "     "endpoint": "http://localhost:81" "
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
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Last-Modified" header value
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Content-MD5" header value
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Length" header value "230"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "597d2ea7-f71f-414d-83f2-971428bfb268", "
        "     "endpoint": "http://localhost:81",             "
        "     "type": "subscription"                         "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Valid mixedcase content-md5 entity-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "bffc140c-224a-4f02-945a-c63efae0170e", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/bffc140c-224a-4f02-945a-c63efae0170e" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-MD5: 3fDadc88e2e5437131CBBA61ed808610":
        """
        " { "data": {                           "
        "     "endpoint": "http://localhost:82" "
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
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Last-Modified" header value
        And I should see a "ETag" header value
        And I should see a "Date" header value
        And I should see a "Content-MD5" header value
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Length" header value "230"
        And I should see a "Connection" header value "close"
        And I should see a "Allow" header value "GET,PUT,HEAD,DELETE,OPTIONS"
        And I should see a "Accept-Ranges" header value "none"
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a response body describing the resource:
        """
        " { "data": {                                        "
        "     "key": "bffc140c-224a-4f02-945a-c63efae0170e", "
        "     "endpoint": "http://localhost:82",             "
        "     "type": "subscription"                         "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Invalid content-md5 entity-header field.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "3182ea11-54f6-45d2-a792-e3b4560a024e", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "PUT" request to "/subscriptions/3182ea11-54f6-45d2-a792-e3b4560a024e" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984, Content-MD5: 3u4osjl":
        """
        " { "data": {                           "
        "     "endpoint": "http://localhost:84" "
        "   }                                   "
        " }                                     "
        """
        Then I should see a response status code of "400" "Bad Request"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "212"
        And I should see a "Content-MD5" header value "c8162f137fe001186d6933d4a6b7a83c"
        And I should see a "Connection" header value "close"
        And I should see a "Expires" header value "0"
        And I should see a "Date" header value
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Retry-After" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                                     "
        "     "type": "error",                                                                                                                            "
        "     "code": 40000,                                                                                                                              "
        "     "status": 400,                                                                                                                              "
        "     "title": "Bad Request",                                                                                                                     "
        "     "message": "The exchange is refusing to process the request because the entity-body failed Content-MD5 end-to-end message integrity check." "
        "   }                                                                                                                                             "
        " }                                                                                                                                               "
        """
