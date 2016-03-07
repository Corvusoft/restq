# language: en

Feature: Limit Query
    In order to restrict the number of resources returned
    As a collection consumer
    I want the ability to limit the number of results

    Scenario Outline: In range limit.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "c44d05f4-1852-43fd-920a-b103e3d2bc7d" },    "
        "     { "name": "Memory Event", "key": "38be42ad-e2cf-443f-be37-79fcbfd4d9e2" }, "
        "     { "name": "Disk Event", "key": "baf78646-a419-4c24-9805-2c06f949a888" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?limit=1" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "172"
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
        "     "key": "c44d05f4-1852-43fd-920a-b103e3d2bc7d",  "
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Out of range limit.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "1f17e026-1c0e-4e9a-8d9d-e72dfe89cd38" },    "
        "     { "name": "Memory Event", "key": "7f971d67-d450-4292-bb45-af776c2cd72c" }, "
        "     { "name": "Disk Event", "key": "5e1a9357-0d07-4d97-9d68-3db8ad605010" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?limit=16" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "506"
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
        "     "key": "1f17e026-1c0e-4e9a-8d9d-e72dfe89cd38",  "
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "7f971d67-d450-4292-bb45-af776c2cd72c",  "
        "     "name": "Memory Event",                         "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "5e1a9357-0d07-4d97-9d68-3db8ad605010",  "
        "     "name": "Disk Event",                           "
        "     "type": "queue"                                 "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Zero limit.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "1f17e026-1c0e-4e9a-8d9d-e72dfe89cd38" },    "
        "     { "name": "Memory Event", "key": "7f971d67-d450-4292-bb45-af776c2cd72c" }, "
        "     { "name": "Disk Event", "key": "5e1a9357-0d07-4d97-9d68-3db8ad605010" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?limit=0" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: Empty collection.
        Given I have started a message exchange
        When I perform a HTTP "GET" request to "/queues?limit=3" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: In range limit of virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "4e3d3e28-7cfa-44ca-9989-87a41d5306a1" },    "
        "     { "name": "Memory Event", "key": "4a7b005a-7e3f-4cf0-a2b6-7607cd645e3e" }, "
        "     { "name": "Disk Event", "key": "da5a64d4-54e9-4126-858e-d10be2f08009" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?keys=4e3d3e28-7cfa-44ca-9989-87a41d5306a1,da5a64d4-54e9-4126-858e-d10be2f08009&limit=1" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "172"
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
        "     "key": "4e3d3e28-7cfa-44ca-9989-87a41d5306a1",  "
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Out of range limit of virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "3642f3aa-2991-4ef8-a354-7f1657c0129e" },    "
        "     { "name": "Memory Event", "key": "2f9ab913-9190-46a0-aa5c-26b460f0434e" }, "
        "     { "name": "Disk Event", "key": "79d31f22-20a0-4d41-b9f3-be65fb13e6ec" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?keys=3642f3aa-2991-4ef8-a354-7f1657c0129e,79d31f22-20a0-4d41-b9f3-be65fb13e6ec&limit=53" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "339"
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
        "     "key": "3642f3aa-2991-4ef8-a354-7f1657c0129e",  "
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   },                                                "
        "   {                                                 "
        "     "key": "79d31f22-20a0-4d41-b9f3-be65fb13e6ec",  "
        "     "name": "Disk Event",                           "
        "     "type": "queue"                                 "
        "   } ]                                               "
        " }                                                   "
        """

    Scenario Outline: Zero limit of virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "c668ee5a-63f4-4568-a7b0-1c14a18c3162" },    "
        "     { "name": "Memory Event", "key": "e6b3cbff-5a22-4a5b-ad6c-da6e768aaef9" }, "
        "     { "name": "Disk Event", "key": "fd27276a-3d1b-4715-bef7-5e9109e887af" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?keys=e6b3cbff-5a22-4a5b-ad6c-da6e768aaef9,fd27276a-3d1b-4715-bef7-5e9109e887af&limit=0" with headers "Accept: application/json, Host: localhost:1984"
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
