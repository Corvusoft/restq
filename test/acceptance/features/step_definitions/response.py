# -*- coding: utf-8 -*-
# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

import json

from lettuce import step, world
from datetime import datetime, timedelta

@step( u'I should see a message arrive at "([^"]*)":$' )
def i_should_see_a_message_arrive_at_uri( step, uri ):
    world.consumer.index = 1 if "index=1" in uri.lower( ) else 0

    actual = world.consumer.message[ world.consumer.index ]
    assert step.multiline == world.consumer.message[ world.consumer.index ], "Failed to find a matching consumer message, '%s' is not equal to '%s'." % ( step.multiline, actual )

@step( u'I should see a message "([^"]*)" header value$' )
def i_should_see_a_message_header_value( step, header ):
    assert header.lower( ) in world.consumer.headers[ world.consumer.index ], "Failed to detect consumer message '%s' header." % header
    assert len( world.consumer.headers[ world.consumer.index ][ header.lower( ) ] ) != 0, "Failed to detect consumer message '%s' header." % header

@step( u'I should see a message "([^"]*)" header value "([^"]*)"$' )
def i_should_see_a_message_header_value_of( step, header, value ):
    assert header.lower( ) in world.consumer.headers[ world.consumer.index ], "Failed to detect consumer message '%s' header." % header

    actual = world.consumer.headers[ world.consumer.index ][ header.lower( ) ]
    assert actual == value, "Failed to find matching consumer message '%s' header value, '%s' is not equal to '%s'." % ( header, value, actual )

@step( u'I should see a message "([^"]*)" query parameter value "([^"]*)"$' )
def i_should_see_a_message_query_parameter_value_of( step, name, value ):
    assert name.lower( ) in world.consumer.query[ world.consumer.index ], "Failed to detect consumer message '%s' query parameter." % name

    actual = world.consumer.query[ world.consumer.index ][ name.lower( ) ][ 0 ]
    assert actual == value, "Failed to find matching consumer message '%s' query parameter value, '%s' is not equal to '%s'." % ( name, value, actual )

@step( u'I should see the exchange shutdown the connection after 5 seconds$' )
def i_should_see_the_exchange_shutdown_the_connection_after( step ):
    assert world.response == None, "Failed to find a closed socket connection."

@step( u'I should see a response status code of "([^"]*)" "([^"]*)"$' )
def i_should_see_a_response_status_code_of( step, status, message ):
    assert world.response.message == message, "Failed to find matching HTTP status message, '%s %s' is not equal to '%s %s'." % ( status, message, world.response.status, world.response.message )
    assert int( world.response.status ) == int( status ), "Failed to find matching HTTP status code, '%s %s' is not equal to '%s %s'." % ( status, message, world.response.status, world.response.message )

@step( u'I should see a "([^"]*)" header value$' )
def i_should_see_a_header_value( step, header ):
    assert header.lower( ) in world.response.headers, "Failed to detect '%s' header." % header
    assert len( world.response.headers[ header.lower( ) ] ) != 0, "Failed to detect '%s' header." % header

@step( u'I should not see a "([^"]*)" header value$' )
def i_should_not_see_a_header_value( step, header ):
    assert header.lower( ) not in world.response.headers, "Failed to detect the abscents of '%s' header value '%s'." % ( header, world.response.headers[ header.lower( ) ] )

@step( u'I should see a "([^"]*)" header value "([^"]*)"$' )
def i_should_see_a_header_value_of( step, header, value ):
    assert header.lower( ) in world.response.headers, "Failed to detect '%s' header." % header

    actual = world.response.headers[ header.lower( ) ]
    assert actual == value, "Failed to find matching '%s' header value, '%s' is not equal to '%s'." % ( header, value, actual )

@step( u'I should see a "([^"]*)" header value with a datestamp of now$' )
def i_should_see_a_header_value_with_a_datestamp_of_now( step, header ):
    if header.lower( ) not in world.response.headers:
        assert False, "Failed to detect '%s' header." % header

    actual = datetime.strptime(  world.response.headers[ header.lower( ) ], '%a, %d %b %Y %H:%M:%S GMT' )

    now = datetime.utcnow( )
    maximum = now + timedelta( seconds = 2 )
    minimum = now - timedelta( seconds = 2 )
    expectation = maximum.strftime( '%a, %d %b %Y %H:%M:%S GMT' )

    assert  actual >= minimum and actual <= maximum, "Failed to find matching '%s' header value, '%s' is not equal to '%s'." % ( header, expectation, actual.strftime( '%a, %d %b %Y %H:%M:%S GMT' ) )

@step( u'I should see a "([^"]*)" header value with a datestamp of now plus "([^"]*)"$' )
def i_should_see_a_header_value_with_a_datestamp_of_now( step, header, delay ):
    if header.lower( ) not in world.response.headers:
        assert False, "Failed to detect '%s' header." % header

    actual = datetime.strptime(  world.response.headers[ header.lower( ) ], '%a, %d %b %Y %H:%M:%S GMT' )

    timeout = int( delay )
    maximum = datetime.utcnow( ) - timedelta( seconds = timeout )
    minimum = maximum - timedelta( seconds = timeout )
    expectation = maximum.strftime( '%a, %d %b %Y %H:%M:%S GMT' )

    assert  actual >= minimum and actual <= maximum, "Failed to find matching '%s' header value, '%s' is not equal to '%s'." % ( header, expectation, actual.strftime( '%a, %d %b %Y %H:%M:%S GMT' ) )

@step( u'I should see a "([^"]*)" header value with a datestamp of now minus "([^"]*)"$' )
def i_should_see_a_header_value_with_a_datestamp_of_now( step, header, delay ):
    if header.lower( ) not in world.response.headers:
        assert False, "Failed to detect '%s' header." % header

    actual = datetime.strptime(  world.response.headers[ header.lower( ) ], '%a, %d %b %Y %H:%M:%S GMT' )

    timeout = int( delay )
    maximum = datetime.utcnow( ) - timedelta( seconds = timeout )
    minimum = maximum - timedelta( seconds = timeout / 2 )
    expectation = maximum.strftime( '%a, %d %b %Y %H:%M:%S GMT' )

    assert  actual >= minimum and actual <= maximum, "Failed to find matching '%s' header value, '%s' is not equal to '%s'." % ( header, expectation, actual.strftime( '%a, %d %b %Y %H:%M:%S GMT' ) )

@step( u'I should see an empty response$' )
def i_should_see_an_empty_response( step ):
    assert world.response.body is None or world.response.body is '', "Failed to find empty response body, None is not equal to '%s'." % world.response.body

@step( u'I should see a response body describing the resource:$' )
def i_should_see_a_response_body_describing_the_resource( step ):
    actual = world.response.body
    expected = json.loads( step.multiline )

    try:
        if isinstance( expected[ "data" ], list ):
            if len( expected[ "data" ] ) > 0 and isinstance( expected[ "data" ][ 0 ], basestring ):
                assert actual[ "data" ] == expected[ "data" ], "Failed to find matching response body, %s" % actual
            else:
                for index, item in enumerate( expected[ "data" ] ):
                    for key in item:
                        assert actual[ "data" ][ index ][ key ] == item[ key ], "Failed to find matching response body, %s" % actual
        else:
            for key in expected[ "data" ]:
                assert actual[ "data" ][ key ] == expected[ "data" ][ key ], "Failed to find matching response body, %s" % actual
    except:
        assert False, "Failed to find matching response body, %s" % actual

@step( u'I should see the response message:$' )
def i_should_see_the_response_message( step ):
    expected = step.multiline
    actual = world.response.body

    assert actual == expected, "Failed to find matching response message, %s" % actual

@step( u'I should see a specific response body describing the resource:$' )
def i_should_see_a_specific_response_body_describing_the_resource( step ):
    expected = json.loads( step.multiline )
    actual = world.response.body

    assert actual == expected, "Failed to find matching response body, %s" % actual

@step( u'I should see the error response:$' )
def i_should_see_the_error_response( step ):
    actual = world.response.body
    expected = json.loads( step.multiline )

    try:
        assert actual[ "data" ][ "type" ] == expected[ "data" ][ "type" ], "Failed to find matching error type, '%s' is not equal to '%s'." % ( expected[ "data" ][ "type" ], actual[ "data" ][ "type" ] )
        assert actual[ "data" ][ "code" ] == expected[ "data" ][ "code" ], "Failed to find matching error code, '%s' is not equal to '%s'." % ( expected[ "data" ][ "code" ], actual[ "data" ][ "code" ] )
        assert actual[ "data" ][ "title" ] == expected[ "data" ][ "title" ], "Failed to find matching error title, '%s' is not equal to '%s'." % ( expected[ "data" ][ "title" ], actual[ "data" ][ "title" ] )
        assert actual[ "data" ][ "status" ] == expected[ "data" ][ "status" ], "Failed to find matching error status, '%s' is not equal to '%s'." % ( expected[ "data" ][ "status" ], actual[ "data" ][ "status" ] )
        assert actual[ "data" ][ "message" ] == expected[ "data" ][ "message" ], "Failed to find matching error message, '%s' is not equal to '%s'." % ( expected[ "data" ][ "message" ], actual[ "data" ][ "message" ] )
    except:
        assert len( actual ) != 0, "Failed to find matching response body, None"
        assert False, "Failed to find matching response body, %s" % actual
