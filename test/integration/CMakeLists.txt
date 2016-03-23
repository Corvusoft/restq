# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

project( "integration test suite" )

cmake_minimum_required( VERSION 2.8.10 )

#
# Configuration
#
set( SOURCE_DIR "source" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCATCH_CONFIG_MAIN" )

include_directories( ${catch_INCLUDE} )

#
# Build
#
add_executable( query_integration_test_suite ${SOURCE_DIR}/query_suite.cpp )
target_link_libraries( query_integration_test_suite ${CMAKE_PROJECT_NAME} )
add_test( query_integration_test_suite ${EXECUTABLE_OUTPUT_PATH}/query_integration_test_suite )

add_executable( exchange_integration_test_suite ${SOURCE_DIR}/exchange_suite.cpp )
target_link_libraries( exchange_integration_test_suite ${CMAKE_PROJECT_NAME} )
add_test( exchange_integration_test_suite ${EXECUTABLE_OUTPUT_PATH}/exchange_integration_test_suite )
