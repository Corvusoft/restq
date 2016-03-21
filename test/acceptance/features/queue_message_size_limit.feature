# language: en

Feature: Queue Message Size Limit
    In order to restrict the maximum allowed message content length
    As a Queue owner
    I want support for limiting a queue's message size in bytes

    Scenario Outline: Exceed default (1024) message size limit.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "6c794571-b987-4421-bdd9-94249ea2d291"  "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "POST" request to "/queues/6c794571-b987-4421-bdd9-94249ea2d291/messages" with headers "Content-Length: 1339, Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " JOHN, by the grace of God King of England, Lord of Ireland, Duke of Normandy and Aquitaine, and Count of Anjou, to his archbishops, bishops, abbots, earls, barons, justices, foresters, sheriffs, stewards, servants, and to all his officials and loyal subjects, Greeting. "
        " KNOW THAT BEFORE GOD, for the health of our soul and those of our ancestors and heirs, to the honour of God, the exaltation of the holy Church, and the better ordering of our kingdom, at the advice of our reverend fathers Stephen, archbishop of Canterbury, primate of all England, and cardinal of the holy Roman Church, Henry archbishop of Dublin, William bishop of London, Peter bishop of Winchester, Jocelin bishop of Bath and Glastonbury, Hugh bishop of Lincoln, Walter bishop of Worcester, William bishop of Coventry, Benedict bishop of Rochester, Master Pandulf subdeacon and member of the papal household, Brother Aymeric master of the knighthood of the Temple in England, William Marshal earl of Pembroke, William earl of Salisbury, William earl of Warren, William earl of Arundel, Alan of Galloway constable of Scotland, Warin fitz Gerald, Peter fitz Herbert, Hubert de Burgh seneschal of Poitou, Hugh de Neville, Matthew fitz Herbert, Thomas Basset, Alan Basset, Philip Daubeny, Robert de Roppeley, John Marshal, John fitz Hugh, and other loyal subjects... "
        """
        Then I should see a response status code of "413" "Request Entity Too Large"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "247"
        And I should see a "Content-MD5" header value "f575ba41f6d3441c8dfb8012d309bfc2"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Allow" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                                                           "
        "     "type": "error",                                                                                                                                                  "
        "     "code": 40013,                                                                                                                                                    "
        "     "status": 413,                                                                                                                                                    "
        "     "title": "Request Entity Too Large",                                                                                                                              "
        "     "message": "The exchange is refusing to process a request because the message entity is larger than the one or more of the queues is willing or able to process." "
        "   }                                                                                                                                                                   "
        " }                                                                                                                                                                     "
        """

    Scenario Outline: Exceed custom message size limit.
        Given I have started a message exchange
        And I perform a HTTP "POST" request to "/queues" with headers "Content-Type: application/json, Accept: application/json, Host: localhost:1984":
        """
        " { "data": {                                        "
        "     "name": "acceptance test queue",               "
        "     "key": "07fe5cb8-a27c-498c-a330-7c9b299b3ec2", "
        "     "message-size-limit": 50                       "
        "   }                                                "
        " }                                                  "
        """
        When I perform a HTTP "POST" request to "/queues/07fe5cb8-a27c-498c-a330-7c9b299b3ec2/messages" with headers "Content-Length: 178, Content-Type: text/plain, Accept: application/json, Host: localhost:1984":
        """
        " Many years ago, a hunter brought a private supply of this exceptional barrel-aged bourbon, on a Wild Turkey hunt, earning its name that is now the benchmark of quailty bourbon. "
        """
        Then I should see a response status code of "413" "Request Entity Too Large"
        And I should see a "Server" header value "corvusoft/restq"
        And I should see a "Content-Type" header value "application/json; charset=utf-8"
        And I should see a "Content-Length" header value "247"
        And I should see a "Content-MD5" header value "f575ba41f6d3441c8dfb8012d309bfc2"
        And I should see a "Connection" header value "close"
        And I should see a "Date" header value
        And I should see a "Expires" header value "0"
        And I should see a "Pragma" header value "no-cache"
        And I should see a "Cache-Control" header value "private,max-age=0,no-cache,no-store"
        And I should see a "Content-Language" header value "en"
        And I should see a "Vary" header value "Accept,Accept-Encoding,Accept-Charset,Accept-Language"
        And I should not see a "WWW-Authenticate" header value
        And I should not see a "Allow" header value
        And I should not see a "Trailer" header value
        And I should not see a "Warning" header value
        And I should not see a "Accept-Ranges" header value
        And I should not see a "ETag" header value
        And I should not see a "Age" header value
        And I should not see a "Retry-After" header value
        And I should not see a "Content-Range" header value
        And I should not see a "Content-Encoding" header value
        And I should not see a "Content-Location" header value
        And I should not see a "Location" header value
        And I should not see a "Last-Modified" header value
        And I should not see a "Via" header value
        And I should not see a "Upgrade" header value
        And I should not see a "Transfer-Encoding" header value
        And I should not see a "Proxy-Authentication" header value
        And I should see the error response:
        """
        " { "data": {                                                                                                                                                           "
        "     "type": "error",                                                                                                                                                  "
        "     "code": 40013,                                                                                                                                                    "
        "     "status": 413,                                                                                                                                                    "
        "     "title": "Request Entity Too Large",                                                                                                                              "
        "     "message": "The exchange is refusing to process a request because the message entity is larger than the one or more of the queues is willing or able to process." "
        "   }                                                                                                                                                                   "
        " }                                                                                                                                                                     "
        """
