# language: en

Feature: Paging Query
    In order to navigate large collections
    As a collection consumer
    I want the ability to select a page of resources with the index and limit query parameters

    Scenario Outline: Page single resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "282d34bd-9c80-42b5-ac95-a407730e7d51" }, "
        "     { "endpoint": "http://localhost:8081", "key": "dc6934de-e9c4-4e86-9122-9598caf1a2e4" }, "
        "     { "endpoint": "http://localhost:8082", "key": "5075ddce-6e3b-4524-920a-5118f86210cb" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/subscriptions?index=1&limit=1" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "212"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": {                                         "
        "     "key": "dc6934de-e9c4-4e86-9122-9598caf1a2e4",  "
        "     "endpoint": "http://localhost:8081",            "
        "     "type": "subscription"                          "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Page multiple resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "2e157d98-773b-455a-94f2-0997799bc140" }, "
        "     { "endpoint": "http://localhost:8081", "key": "f67b1ddb-5cd2-4fe3-9cab-5c513a725e76" }, "
        "     { "endpoint": "http://localhost:8082", "key": "031639b9-bfaf-49f7-aebd-d55c84f993c1" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/subscriptions?index=0&limit=2" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "418"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": [ {                                       "
        "     "key": "2e157d98-773b-455a-94f2-0997799bc140",  "
        "     "endpoint": "http://localhost:8080",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "f67b1ddb-5cd2-4fe3-9cab-5c513a725e76",  "
        "     "endpoint": "http://localhost:8081",            "
        "     "type": "subscription"                          "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Page all resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "965e86a7-ced8-48e2-95d5-861a72a56c3c" }, "
        "     { "endpoint": "http://localhost:8081", "key": "5177e858-5b09-4e28-ad38-8b0fe33ec435" }, "
        "     { "endpoint": "http://localhost:8082", "key": "0c5a7ded-7a73-4e88-b372-671e44186ad9" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/subscriptions?index=0&limit=300" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "622"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": [ {                                       "
        "     "key": "965e86a7-ced8-48e2-95d5-861a72a56c3c",  "
        "     "endpoint": "http://localhost:8080",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "5177e858-5b09-4e28-ad38-8b0fe33ec435",  "
        "     "endpoint": "http://localhost:8081",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "0c5a7ded-7a73-4e88-b372-671e44186ad9",  "
        "     "endpoint": "http://localhost:8082",            "
        "     "type": "subscription"                          "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Page non-existent resources.
        Given I have started a message exchange
        When I perform a HTTP "GET" request to "/subscriptions?limit=37&index=5" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "11"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "ETag" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": [ ] } "
        """

    Scenario Outline: Page virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "d9aabbcc-f443-480e-99ac-452c49ecf5bd" }, "
        "     { "endpoint": "http://localhost:8081", "key": "67e3b9f1-1563-4966-bc34-8c7971335e13" }, "
        "     { "endpoint": "http://localhost:8082", "key": "2a82de98-e93f-4ad3-a481-1a2dd3cfcdfc" }, "
        "     { "endpoint": "http://localhost:8083", "key": "71a9d287-b3c9-45ed-af24-7a856b87e70a" }, "
        "     { "endpoint": "http://localhost:8084", "key": "fd06d32d-a9e9-41df-a949-aef477c731ed" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/subscriptions?keys=d9aabbcc-f443-480e-99ac-452c49ecf5bd,2a82de98-e93f-4ad3-a481-1a2dd3cfcdfc,71a9d287-b3c9-45ed-af24-7a856b87e70a&index=1&limit=2" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "418"
        And I should see a "Content-MD5" header value
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "ETag" header value
        And I should see a "Last-Modified" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Language" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Location" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see a response body describing the resource:
        """
        " { "data": [ {                                       "
        "     "key": "2a82de98-e93f-4ad3-a481-1a2dd3cfcdfc",  "
        "     "endpoint": "http://localhost:8082",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "71a9d287-b3c9-45ed-af24-7a856b87e70a",  "
        "     "endpoint": "http://localhost:8083",            "
        "     "type": "subscription"                          "
        "   } ]                                               "
        " }                                                   "
        """
