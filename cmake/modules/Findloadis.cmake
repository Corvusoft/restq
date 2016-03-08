# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

find_path( loadis_INCLUDE loadis HINTS "${CMAKE_SOURCE_DIR}/dependency/loadis/source" )

if ( loadis_INCLUDE )
    set( loadis_FOUND TRUE )
    message( STATUS "${Green}Found Loadis include at: ${loadis_INCLUDE}${Reset}" )
else ( )
    message( FATAL_ERROR "${Red}Failed to locate Loadis dependency.${Reset}" )
endif ( )
