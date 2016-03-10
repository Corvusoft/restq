# language: en

Feature: Filter Query
    In order to filter out resources of interest
    As a collection consumer
    I want the ability extract resources based on their properties

    Scenario Outline: Single filter.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "fcd1e737-8e73-4acf-a1c3-c5f8847ae2ab" },    "
        "     { "name": "Memory Event", "key": "b58c085b-43ab-4f68-8986-c120ec3bf1d9" }, "
        "     { "name": "Disk Event", "key": "88ddd218-fdfb-4653-ad6d-5137ca67d41f" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?name=CPU%20Event" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "189"
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
        "     "key": "fcd1e737-8e73-4acf-a1c3-c5f8847ae2ab",  "
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Multiple filters.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                "
        "     { "name": "CPU Event", "level": 1, "key": "8b9689ee-e92f-4af5-8807-01a701bb189e" },    "
        "     { "name": "Memory Event", "level": 2, "key": "55626246-3731-42c3-bb5b-55cb39e01730" }, "
        "     { "name": "Disk Event", "level": 2, "key": "463d18ad-811d-4002-932f-927a93c9032a" }    "
        "   ]                                                                                        "
        " }                                                                                          "
        """
        When I perform a HTTP "GET" request to "/queues?name=Memory%20Event&level=2" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "202"
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
        "     "key": "55626246-3731-42c3-bb5b-55cb39e01730",  "
        "     "name": "Memory Event",                         "
        "     "level": 2,                                     "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Filter by matched unordered-set.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                            "
        "     { "name": [ "a", "b", "c", "d" ], "key": "35854d68-d10a-483e-ba5c-b735ab4208e8" }, "
        "     { "name": [ "a", "a", "c", "d" ], "key": "f7c23f62-9832-41bf-8180-a03127936584" }, "
        "     { "name": [ "a", "e", "f", "d" ], "key": "400d0881-c3a4-4968-a766-3c18c02efa84" }  "
        "   ]                                                                                    "
        " }                                                                                      "
        """
        When I perform a HTTP "GET" request to "/queues?name=e,f" with headers "Accept: application/json, Host: localhost:1984"
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
        "     "key": "400d0881-c3a4-4968-a766-3c18c02efa84",  "
        "     "name": [ "a", "e", "f", "d" ],                 "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Filter by unmatched unordered-set.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                            "
        "     { "name": [ "a", "b", "c", "d" ], "key": "84d931b4-1cbd-413d-b2e4-754449e37dcc" }, "
        "     { "name": [ "a", "a", "c", "d" ], "key": "f4c638a8-bfa0-4623-a8c0-605bb8318eab" }, "
        "     { "name": [ "a", "e", "f", "d" ], "key": "9468a188-0f38-4c9f-ac2f-7d2e5affbb6f" }  "
        "   ]                                                                                    "
        " }                                                                                      "
        """
        When I perform a HTTP "GET" request to "/queues?name=rain,auckland" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: Unknown filter.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "4e608f3c-9c58-4659-924e-c3846fc50e72" },    "
        "     { "name": "Memory Event", "key": "88107c08-a05e-4b64-876d-0f3840c9f90f" }, "
        "     { "name": "Disk Event", "key": "80761615-77d1-42f2-b96f-d2767583c2d6" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?author=Ben" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: Mismatched filter.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "272eb8ce-9c0b-4d1e-8833-7ff6cd538333" },    "
        "     { "name": "Memory Event", "key": "bf9ba5b1-1bfd-4ea8-b43a-0837ce08278d" }, "
        "     { "name": "Disk Event", "key": "60484a2a-494f-4044-a949-06153bf3f0e1" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?name=DMA%20Event" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: Single filter on a virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "31fbac72-5250-4081-af64-227e83d9b8f3" },    "
        "     { "name": "Memory Event", "key": "ff7f81ac-99d7-45bb-8760-5b481422bab1" }, "
        "     { "name": "Disk Event", "key": "37f376fb-8b45-47c3-85e3-63b487ff42cf" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?keys=37f376fb-8b45-47c3-85e3-63b487ff42cf,31fbac72-5250-4081-af64-227e83d9b8f3&name=CPU%20Event" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "189"
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
        "     "key": "31fbac72-5250-4081-af64-227e83d9b8f3",  "
        "     "name": "CPU Event",                            "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Multiple filters on a virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                                "
        "     { "name": "CPU Event", "level": 1, "key": "efbdb88b-a070-433b-8ee3-d50776cc0002" },    "
        "     { "name": "Memory Event", "level": 2, "key": "68b958f5-3e49-4a57-beb5-c97600c365a6" }, "
        "     { "name": "Disk Event", "level": 2, "key": "952b0be9-7dac-4bbb-a601-3ec1076a8b74" }    "
        "   ]                                                                                        "
        " }                                                                                          "
        """
        When I perform a HTTP "GET" request to "/queues?keys=952b0be9-7dac-4bbb-a601-3ec1076a8b74,68b958f5-3e49-4a57-beb5-c97600c365a6&name=Memory%20Event&level=2" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "200" "OK"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "202"
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
        "     "key": "68b958f5-3e49-4a57-beb5-c97600c365a6",  "
        "     "name": "Memory Event",                         "
        "     "level": 2,                                     "
        "     "type": "queue"                                 "
        "   }                                                 "
        " }                                                   "
        """

    Scenario Outline: Unknown filter on a virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "74fa16a2-bfaa-448b-a791-a453e225f264" },    "
        "     { "name": "Memory Event", "key": "432e86ae-d7cf-4b16-bf5b-98869f63abab" }, "
        "     { "name": "Disk Event", "key": "5f524670-91ca-483b-9896-f66c32ec132f" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?author=Ben&keys=432e86ae-d7cf-4b16-bf5b-98869f63abab,5f524670-91ca-483b-9896-f66c32ec132f" with headers "Accept: application/json, Host: localhost:1984"
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

    Scenario Outline: Mismatched filter on virtual collection.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": [                                                                    "
        "     { "name": "CPU Event", "key": "a606aaad-8132-49b9-8429-58f047e0d34a" },    "
        "     { "name": "Memory Event", "key": "4ebbc476-e977-41e7-b123-848f964191b6" }, "
        "     { "name": "Disk Event", "key": "4cf6a98e-c676-4e0a-8751-aca6cb9ebc20" }    "
        "   ]                                                                            "
        " }                                                                              "
        """
        When I perform a HTTP "GET" request to "/queues?name=DMA%20Event&keys=a606aaad-8132-49b9-8429-58f047e0d34a,4cf6a98e-c676-4e0a-8751-aca6cb9ebc20" with headers "Accept: application/json, Host: localhost:1984"
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
