# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

find_path( md5_INCLUDE md5.h HINTS "${CMAKE_SOURCE_DIR}/dependency/md5/include" "/usr/include" "/usr/local/include" "/opt/local/include" )

if ( md5_INCLUDE )
    set( MD5_FOUND TRUE )

    message( STATUS "${Green}Found MD5 include at: ${md5_INCLUDE}${Reset}" )
else ( )
    message( FATAL_ERROR "${Red}Failed to locate MD5 dependency.${Reset}" )
endif ( )
