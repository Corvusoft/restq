# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

project( "unit test suite" )

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
add_executable( string_unit_test_suite ${SOURCE_DIR}/string_suite.cpp )
target_link_libraries( string_unit_test_suite ${CMAKE_PROJECT_NAME} )
add_test( string_unit_test_suite ${EXECUTABLE_OUTPUT_PATH}/string_unit_test_suite )

add_executable( exchange_unit_test_suite ${SOURCE_DIR}/exchange_suite.cpp )
target_link_libraries( exchange_unit_test_suite ${CMAKE_PROJECT_NAME} )
add_test( exchange_unit_test_suite ${EXECUTABLE_OUTPUT_PATH}/exchange_unit_test_suite )
