# -*- coding: utf-8 -*-
# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

import time

from lettuce import step, world

@step( u'I have started a message exchange$' )
def i_have_started_a_message_exchange( step ):
    step.behave_as(
    """
        When I perform a HTTP "OPTIONS" request to "/*" with headers "Accept: application/json, Host: localhost:1984"
        Then I should see a response status code of "204" "No Content"
    """ )

@step( u'I wait "([^"]*)" seconds$' )
def i_wait_for_n_seconds( step, delay ):
	time.sleep( int( delay ) )
