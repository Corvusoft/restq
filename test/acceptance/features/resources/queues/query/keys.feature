# language: en

Feature: Keys Query
    In order to filter collection resources
    As a collection consumer
    I want the ability to select a range of resources based on their keys

    Scenario Outline: Read single resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "59b12c73-af43-4253-8125-b9b025264c54", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "GET" request to "/queues?keys=59b12c73-af43-4253-8125-b9b025264c54" with headers "Accept: application/json, Host: localhost:1984"
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
        "     "type": "queue",                               "
        "     "key": "59b12c73-af43-4253-8125-b9b025264c54", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """

    Scenario Outline: Read multiple resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "name": "acceptance-test", "key": "3d6960ca-8b6e-4157-a0ee-f1ad20442abf" },           "
        "     { "name": "additional-acceptance-test", "key": "0666c92e-3c9e-47b6-b467-961ca9fe6d0d" } "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/queues?keys=3d6960ca-8b6e-4157-a0ee-f1ad20442abf,0666c92e-3c9e-47b6-b467-961ca9fe6d0d" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "395"
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
        "     "name": "acceptance-test",                      "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "0666c92e-3c9e-47b6-b467-961ca9fe6d0d",  "
        "     "name": "additional-acceptance-test",           "
        "     "type": "queue"                                 "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Read subset of available resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "87e8d113-3db5-42f5-9da3-8e669149ec9d" },    "
        "     { "name": "Memory Event", "key": "9bcf6775-b76f-4a47-a20a-1e18b3874b18" }, "
        "     { "name": "Disk Event", "key": "af4fca5b-fadc-4b26-b69d-1d0e26121acc" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?keys=87e8d113-3db5-42f5-9da3-8e669149ec9d,af4fca5b-fadc-4b26-b69d-1d0e26121acc" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "373"
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
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "af4fca5b-fadc-4b26-b69d-1d0e26121acc",  "
        "     "name": "Disk Event",                           "
        "     "type": "queue"                                 "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Read non-existent resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "name": "acceptance-test", "id": "14bbf31c-1d8a-407f-9299-19242ac7f6bd" },            "
        "     { "name": "additional-acceptance-test", "id": "8e47d5d5-1706-4c1f-b635-533d0d9b4083" }  "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        When I perform a HTTP "GET" request to "/queues?keys=14bbf31c-1d8a-407f-9299-19242ac7f6bd,c0f22109-d258-4458-a3f5-0d16b2f55487" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "404" "Not Found"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "197"
        And I should see a "Content-MD5" header value "8cf1a2abe9cf949d737d4aae1dd3b45c"
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "9cfeb640-87eb-45ec-b28e-dea1b0d128f5" },    "
        "     { "name": "Memory Event", "key": "9666701b-9839-4b9c-b87b-b58bbbe49ee6" }, "
        "     { "name": "Disk Event", "key": "7fbcb276-c1fb-4a6e-8271-968329f54468" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?keys=9666701b-9839-4b9c-b87b-b58bbbe49ee6,7fbcb276-c1fb-4a6e-8271-968329f54468,9cfeb640-87eb-45ec-b28e-dea1b0d128f5" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "557"
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
        "     "name": "Memory Event",                         "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "7fbcb276-c1fb-4a6e-8271-968329f54468",  "
        "     "name": "Disk Event",                           "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "9cfeb640-87eb-45ec-b28e-dea1b0d128f5",  "
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Delete single resource.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "key": "11694314-eca9-4bf2-9272-91018c934115", "
        "     "name": "acceptance-test"                      "
        "   }                                                "
        " }                                                  "
        """
        And I perform a HTTP "DELETE" request to "/queues?keys=11694314-eca9-4bf2-9272-91018c934115" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/queues" with headers "Accept: application/json, Host: localhost:1984"
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "name": "acceptance-test", "key": "7f0a5db1-4c0c-4ef8-b930-58375f28c80d" },           "
        "     { "name": "additional-acceptance-test", "key": "c1b157f3-66d7-4d27-b1d3-9e1638964f71" } "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        And I perform a HTTP "DELETE" request to "/queues?keys=7f0a5db1-4c0c-4ef8-b930-58375f28c80d,c1b157f3-66d7-4d27-b1d3-9e1638964f71" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/queues" with headers "Accept: application/json, Host: localhost:1984"
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
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "9d8c974a-8c18-4e8f-b92f-1a655a6dd0e1" },    "
        "     { "name": "Memory Event", "key": "2c261c06-249e-49f3-9c78-cd2f2a50356e" }, "
        "     { "name": "Disk Event", "key": "2ff233ce-e261-4964-ba04-bb1f91fdff28" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        And I perform a HTTP "DELETE" request to "/queues?keys=9d8c974a-8c18-4e8f-b92f-1a655a6dd0e1,2ff233ce-e261-4964-ba04-bb1f91fdff28" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/queues" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "192"
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
        "     "name": "Memory Event",                         "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Delete non-existent resources.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                 "
        "     { "name": "acceptance-test", "key": "b9f0abb3-b98c-44fc-a40b-522719604114" },           "
        "     { "name": "additional-acceptance-test", "key": "1838695e-b912-456c-b156-8eb3bb66aa6e" } "
        "   ]                                                                                         "
        " }                                                                                           "
        """
        And I perform a HTTP "DELETE" request to "/queues?keys=b9f0abb3-b98c-44fc-a40b-522719604114,c1b157f3-66d7-4d27-b1d3-9e1638964f71" with headers "Accept: application/json, Host: localhost:1984"
        When I perform a HTTP "GET" request to "/queues" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "395"
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
        "     "key": "b9f0abb3-b98c-44fc-a40b-522719604114",  "
        "     "name": "acceptance-test",                      "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "1838695e-b912-456c-b156-8eb3bb66aa6e",  "
        "     "name": "additional-acceptance-test",           "
        "     "type": "queue"                                 "
        "   } ]                                               "
        " }                                                   "
        """
