# language: en

Feature: Keys Query
    In order to filter collection resources
    As a collection consumer
    I want the ability to select a range of resources based on their keys

    Scenario Outline: Read single resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "59b12c73-af43-4253-8125-b9b025264c54", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/subscriptions?keys=59b12c73-af43-4253-8125-b9b025264c54" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "195"
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
        " { "data": {                                        "
        "     "type": "subscription",                        "
        "     "key": "59b12c73-af43-4253-8125-b9b025264c54", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Read multiple resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "3d6960ca-8b6e-4157-a0ee-f1ad20442abf" }, "
        "     { "endpoint": "http://localhost:8040", "key": "0666c92e-3c9e-47b6-b467-961ca9fe6d0d" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/subscriptions?keys=3d6960ca-8b6e-4157-a0ee-f1ad20442abf,0666c92e-3c9e-47b6-b467-961ca9fe6d0d" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "384"
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
        "     "key": "3d6960ca-8b6e-4157-a0ee-f1ad20442abf",  "
        "     "endpoint": "http://localhost:8080",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "0666c92e-3c9e-47b6-b467-961ca9fe6d0d",  "
        "     "endpoint": "http://localhost:8040",            "
        "     "type": "subscription"                          "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Read subset of available resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "87e8d113-3db5-42f5-9da3-8e669149ec9d" }, "
        "     { "endpoint": "http://localhost:8081", "key": "9bcf6775-b76f-4a47-a20a-1e18b3874b18" }, "
        "     { "endpoint": "http://localhost:8082", "key": "af4fca5b-fadc-4b26-b69d-1d0e26121acc" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/subscriptions?keys=87e8d113-3db5-42f5-9da3-8e669149ec9d,af4fca5b-fadc-4b26-b69d-1d0e26121acc" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "384"
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
        "     "key": "87e8d113-3db5-42f5-9da3-8e669149ec9d",  "
        "     "endpoint": "http://localhost:8080",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "af4fca5b-fadc-4b26-b69d-1d0e26121acc",  "
        "     "endpoint": "http://localhost:8082",            "
        "     "type": "subscription"                          "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Read non-existent resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                "
        "     { "endpoint": "http://localhost:8080", "id": "14bbf31c-1d8a-407f-9299-19242ac7f6bd" }, "
        "     { "endpoint": "http://localhost:8040", "id": "8e47d5d5-1706-4c1f-b635-533d0d9b4083" }  "
        "   ]                                                                                        "
        " }                                                                                          "
        """
        When I perform a HTTP "GET" request to "/subscriptions?keys=14bbf31c-1d8a-407f-9299-19242ac7f6bd,c0f22109-d258-4458-a3f5-0d16b2f55487" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "404" "Not Found"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "197"
        And I should see a "Content-MD5" header value "8CF1A2ABE9CF949D737D4AAE1DD3B45C"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Allow" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
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
        " { "data": {                                                                                                                        "
        "     "type": "error",                                                                                                               "
        "     "code": 40004,                                                                                                                 "
        "     "status": 404,                                                                                                                 "
        "     "title": "Not Found",                                                                                                          "
        "     "message": "The exchange is refusing to process the request because the requested URI could not be found within the exchange." "
        "   }                                                                                                                                "
        " }                                                                                                                                  "
        """

    Scenario Outline: Read resources in custom order.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "9cfeb640-87eb-45ec-b28e-dea1b0d128f5" }, "
        "     { "endpoint": "http://localhost:8081", "key": "9666701b-9839-4b9c-b87b-b58bbbe49ee6" }, "
        "     { "endpoint": "http://localhost:8082", "key": "7fbcb276-c1fb-4a6e-8271-968329f54468" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/subscriptions?keys=9666701b-9839-4b9c-b87b-b58bbbe49ee6,7fbcb276-c1fb-4a6e-8271-968329f54468,9cfeb640-87eb-45ec-b28e-dea1b0d128f5" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "571"
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
        "     "key": "9666701b-9839-4b9c-b87b-b58bbbe49ee6",  "
        "     "endpoint": "http://localhost:8081",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "7fbcb276-c1fb-4a6e-8271-968329f54468",  "
        "     "endpoint": "http://localhost:8082",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "9cfeb640-87eb-45ec-b28e-dea1b0d128f5",  "
        "     "endpoint": "http://localhost:8080",            "
        "     "type": "subscription"                          "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Delete single resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "11694314-eca9-4bf2-9272-91018c934315", "
        "     "endpoint": "http://localhost:8080"            "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "DELETE" request to "/subscriptions?keys=11694314-eca9-4bf2-9272-91018c934315" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/subscriptions" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: Delete multiple resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "7f0a5db1-4c0c-4ef8-b930-58375f28c80d" }, "
        "     { "endpoint": "http://localhost:8040", "key": "c1b157f3-66d7-4d27-b1d3-9e1638964f71" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        And I perform a HTTP "DELETE" request to "/subscriptions?keys=7f0a5db1-4c0c-4ef8-b930-58375f28c80d,c1b157f3-66d7-4d27-b1d3-9e1638964f71" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/subscriptions" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: Delete subset of available resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "9d8c974a-8c18-4e8f-b92f-1a655a6dd0e1" }, "
        "     { "endpoint": "http://localhost:8081", "key": "2c261c06-249e-49f3-9c78-cd2f2a50356e" }, "
        "     { "endpoint": "http://localhost:8082", "key": "2ff233ce-e261-4964-ba04-bb1f91fdff28" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        And I perform a HTTP "DELETE" request to "/subscriptions?keys=9d8c974a-8c18-4e8f-b92f-1a655a6dd0e1,2ff233ce-e261-4964-ba04-bb1f91fdff28" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/subscriptions" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "195"
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
        "     "key": "2c261c06-249e-49f3-9c78-cd2f2a50356e",  "
        "     "endpoint": "http://localhost:8081",            "
        "     "type": "subscription"                          "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Delete non-existent resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/subscriptions" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "endpoint": "http://localhost:8080", "key": "b9f0abb3-b98c-44fc-a40b-522719504114" }, "
        "     { "endpoint": "http://localhost:8040", "key": "1838295e-b912-456c-b156-8eb3bb66aa6e" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        And I perform a HTTP "DELETE" request to "/subscriptions?keys=b9f0abb3-b98c-44fc-a40b-522719504114,c1b157f3-66d7-4d27-b1d3-9e1638964f71" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/subscriptions" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "384"
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
        "     "key": "b9f0abb3-b98c-44fc-a40b-522719504114",  "
        "     "endpoint": "http://localhost:8080",            "
        "     "type": "subscription"                          "
        "   },                                                "
        "   {                                                 "
        "     "key": "1838295e-b912-456c-b156-8eb3bb66aa6e",  "
        "     "endpoint": "http://localhost:8040",            "
        "     "type": "subscription"                          "
        "   } ]                                               "
        " }                                                   "
        """
