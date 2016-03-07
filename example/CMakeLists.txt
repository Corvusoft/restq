# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

project( "examples" )

cmake_minimum_required( VERSION 2.8.10 )

#
# Configuration
#
set( EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/example" )

#
# Build
#
add_executable( http_exchange http_exchange/source/example.cpp
                              http_exchange/source/stdout_logger.cpp
                              http_exchange/source/json_formatter.cpp
                              http_exchange_source/stl_repository.cpp )

target_link_libraries( http_exchange ${CMAKE_PROJECT_NAME} )

#
# Install
#
install( DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/example" DESTINATION ${CMAKE_INSTALL_PREFIX} FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE )
