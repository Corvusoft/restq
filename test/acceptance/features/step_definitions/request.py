# -*- coding: utf-8 -*-
# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

import sys
import json
import httplib

from urlparse import urlparse
from lettuce import step, world

@step( u'I perform a HTTP "([^"]*)" request to "([^"]*)"$' )
def i_perform_a_http_method_request_to_path( step, method, path ):
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, dict( ) )

@step( u'I perform a HTTP "([^"]*)" request to "([^"]*)":$' )
def i_perform_a_http_method_request_to_path_with_body( step, method, path ):
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, dict( ) )

@step( u'I perform a HTTP "([^"]*)" request to "([^"]*)" with header "([^"]*)"$' )
def i_perform_a_http_method_request_to_path_with_header( step, method, path, header ):
    value = header.split( ":" );
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, { value[ 0 ]: value[ 1 ] } )

@step( u'I perform a HTTP "([^"]*)" request to "([^"]*)" with header "([^"]*)":$' )
def i_perform_a_http_method_request_to_path_with_header_and_body( step, method, path, header ):
    value = header.split( ":" );
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, { value[ 0 ]: value[ 1 ] } )

@step( u'I perform a HTTP "([^"]*)" request to "([^"]*)" with only headers "([^"]*)":$' )
def i_perform_a_http_method_request_to_path_with_only_headers_and_body( step, method, path, header ):
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, header, True )

@step( u'I perform a HTTP "([^"]*)" request to "([^"]*)" with headers "(.*)"$' )
def i_perform_a_http_method_request_to_path_with_headers( step, method, path, headers ):
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, headers )

@step( u'I perform a HTTP "([^"]*)" request to the last response "([^"]*)" header value with header "(.*)"$' )
def i_perform_a_http_method_request_to_the_last_response_header_with_header( step, method, path, header ):
    value = header.split( ":" );
    assert path.lower( ) in world.response.headers, "Failed to detect the presents of '%s' header value." % ( header )
    path = world.response.headers[ path.lower( ) ]
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, { value[ 0 ]: value[ 1 ] } )

@step( u'I perform a HTTP "([^"]*)" request to the last response "([^"]*)" header value with headers "(.*)"$' )
def i_perform_a_http_method_request_to_the_last_response_header_with_headers( step, method, header, headers ):
    assert header.lower( ) in world.response.headers, "Failed to detect the presents of '%s' header value." % ( header )
    path = world.response.headers[ header.lower( ) ]
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, headers )

@step( u'I perform a HTTP "([^"]*)" request to the last response "([^"]*)" header value with headers "(.*)":$' )
def i_perform_a_http_method_request_to_the_last_response_header_with_headers_and_body( step, method, header, headers ):
    assert header.lower( ) in world.response.headers, "Failed to detect the presents of '%s' header value." % ( header )
    path = world.response.headers[ header.lower( ) ]
    i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, headers )

@step( u'I perform a HTTP "([^"]*)" request to "([^"]*)" with headers "(.*)":$' )
def i_perform_a_http_method_request_to_path_with_headers_and_body( step, method, path, headers, removeContentType = False ):
    request_method = method.upper( )

    request_url = urlparse( path if path.startswith( "http://" ) else world.url + path )

    request_body = ""

    try:
        request_body = json.loads( step.multiline )
        request_body = json.dumps( body )
    except:
        request_body = step.multiline

    request_headers = { "User-Agent": "RestQ Acceptance Tests" };

    if isinstance( headers, dict ):
        request_headers = dict( request_headers.items( ) + headers.items( ) )
    else:
        for value in headers.split( ", " ):
            offset = value.index( ":" )
            header_name = value[ 0 : offset ]
            header_value = value[ offset + 2 :  ]
            request_headers[ header_name ] = header_value

    if not removeContentType and not ( "Content-Length" in request_headers ):
        request_headers[ "Content-Length" ] = len( request_body )

    connection = httplib.HTTPConnection( request_url.netloc )

    request_path = request_url.path
    if request_url.query:
        request_path += "?" + request_url.query

    connection.putrequest( request_method, request_path, skip_accept_encoding = True, skip_host = True )

    for name, value in request_headers.iteritems( ):
        connection.putheader( name, value )

    connection.endheaders( )
    connection.send( request_body )

    response = None

    try:
        response = connection.getresponse( )
    except ( httplib.HTTPException ) as ex:
        world.response = None
        return
  
    body = ""

    try:
        body = response.read( );
    except httplib.IncompleteRead, error:
        body = error.partial

    try:
        response_body = json.loads( body )
    except:
        response_body = body

    world.response = type( "Response", ( object, ), dict( status = response.status, message = response.reason, headers = dict( response.getheaders( ) ), body = response_body ) )
