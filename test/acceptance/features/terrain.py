# -*- coding: utf-8 -*-
# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

import requests
import urlparse
from lettuce import *
from threading import Thread
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer

class Consumer( BaseHTTPRequestHandler ):
    query = [ None, None ]
    headers = [ None, None ]
    message = [ None, None ]

    def do_POST( self ):
        query_parameters = urlparse.parse_qs( urlparse.urlparse( self.path ).query )
        
        index = 1 if "index" in query_parameters and query_parameters[ "index" ][ 0 ] == "1" else 0

        Consumer.headers[ index ] = self.headers
        Consumer.query[ index ] = query_parameters
        Consumer.message[ index ] = self.rfile.read( int( self.headers[ 'Content-Length' ] ) )

        self.send_response( 202 )
        self.end_headers( )
        return

    def log_message( self, format, *args ):
        return

def run( consumer ):
    consumer.serve_forever( );

@before.all
def before_all( ):
    world.port = 1984
    world.url = "http://localhost:" + str( world.port )

    world.consumer = Consumer
    world.httpd = HTTPServer( ( "localhost", 1985 ), Consumer )
    Thread( target = run, args = ( world.httpd, ) ).start( )

@before.each_scenario
def before_each( senario ):
    delete_resources( )

def delete_resources( ):
    headers = { }
    headers[ "Host" ] = "localhost:1984"
    headers[ "Accept" ] = "application/json"
    headers[ "Accept-Encoding" ] = "identity"
    response = requests.delete( world.url + "/queues", headers = headers )
    response = requests.delete( world.url + "/subscriptions", headers = headers )

@after.all
def after_all( total ):
    world.httpd.shutdown( )
