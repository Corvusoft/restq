# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

find_path( restbed_SOURCE CMakeLists.txt HINTS "${CMAKE_SOURCE_DIR}/dependency/restbed" )

if ( restbed_SOURCE )
    set( restbed_FOUND TRUE )
    set( restbed_BUILD "${CMAKE_CURRENT_BINARY_DIR}/restbed_build" )
    set( restbed_DISTRIBUTION "${CMAKE_CURRENT_BINARY_DIR}/distribution" )

    include( ExternalProject )
    ExternalProject_Add( restbed SOURCE_DIR ${restbed_SOURCE}
                         PREFIX restbed_build
                         INSTALL_DIR ${restbed_DISTRIBUTION}
                         CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${restbed_DISTRIBUTION} -DBUILD_SSL=${BUILD_SSL} -DBUILD_SHARED=NO )

    set( restbed_INCLUDE "${restbed_DISTRIBUTION}/include" )
    set( restbed_LIBRARY "${restbed_DISTRIBUTION}/library/${CMAKE_STATIC_LIBRARY_PREFIX}restbed${CMAKE_STATIC_LIBRARY_SUFFIX}" )

    message( STATUS "${Green}Found Restbed include at: ${restbed_SOURCE}${Reset}" )
else ( )
    message( FATAL_ERROR "${Red}Failed to locate Restbed dependency.${Reset}" )
endif ( )
