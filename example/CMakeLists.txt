# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

project( "example" )

cmake_minimum_required( VERSION 2.8.10 )

#
# Configuration
#
set( EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/example" )

include_directories( SYSTEM ${json_INCLUDE} ${restq_INCLUDE} )

#
# Build
#
add_executable( exchange exchange/source/example.cpp
                         exchange/source/stdout_logger.cpp
                         exchange/source/json_formatter.cpp
                         exchange/source/stl_repository.cpp )

target_link_libraries( exchange ${CMAKE_PROJECT_NAME} )

#
# Install
#
install( DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/example" DESTINATION ${CMAKE_INSTALL_PREFIX} FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE )
