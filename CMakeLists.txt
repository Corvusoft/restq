# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

project( "restq" )

cmake_minimum_required( VERSION 2.8.10 )

#
# Build Options
#
option( BUILD_SHARED   "Build shared library."              OFF )
option( BUILD_EXAMPLES "Build examples applications."       OFF )
option( BUILD_TESTS    "Build all available test suites."   OFF )
option( BUILD_SSL      "Build secure socket layer support."  ON )

#
# Configuration
#
include( "${CMAKE_SOURCE_DIR}/cmake/build_configuration.cmake" )

message( "   ${Blue}Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.${Reset}" )

#
# Dependencies
#
set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules" )

find_package( md5 REQUIRED )
find_package( loadis REQUIRED )
find_package( restbed REQUIRED )
find_package( kashmir REQUIRED )

include_directories( SYSTEM ${md5_INCLUDE} ${loadis_INCLUDE} ${restbed_INCLUDE} ${kashmir_INCLUDE} )

if ( BUILD_SSL )
    find_package( openssl REQUIRED )
    include_directories( SYSTEM ${ssl_INCLUDE} )
endif ( )

#
# Build
#
include( "${CMAKE_SOURCE_DIR}/cmake/build_manifest.cmake" )

include_directories( ${INCLUDE_DIR} )

add_library( ${PROJECT_NAME} ${BUILD_MANIFEST} )

if ( BUILD_SSL )
    target_link_libraries( ${PROJECT_NAME} LINK_PRIVATE ${restbed_LIBRARY} ${ssl_LIBRARY} ${crypto_LIBRARY} )
else ( )
    target_link_libraries( ${PROJECT_NAME} LINK_PRIVATE ${restbed_LIBRARY} )
endif ( )

if ( BUILD_EXAMPLES )
    find_package( json REQUIRED )
    add_subdirectory( "${CMAKE_SOURCE_DIR}/example" )
endif ( )

if ( BUILD_TESTS )
    find_package( catch REQUIRED )

    enable_testing( )
    add_subdirectory( "${CMAKE_SOURCE_DIR}/test/unit" "unit-tests" )
    add_subdirectory( "${CMAKE_SOURCE_DIR}/test/integration" "integration-tests" )
endif ( )

#
# Install
#
include( "${CMAKE_SOURCE_DIR}/cmake/build_artifacts.cmake" )

install( FILES "${INCLUDE_DIR}/${PROJECT_NAME}" DESTINATION "include" )
install( FILES ${BUILD_ARTIFACTS} DESTINATION "include/corvusoft/${PROJECT_NAME}" )
install( TARGETS ${PROJECT_NAME}
         LIBRARY DESTINATION "library"
         ARCHIVE DESTINATION "library" COMPONENT library )
