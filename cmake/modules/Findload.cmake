# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

find_path( load_INCLUDE cpu.h memory.h HINTS "${CMAKE_SOURCE_DIR}/dependency/load/common" )

if ( load_INCLUDE )
    set( LOAD_FOUND TRUE )
    set( LOAD_SOURCE_DIR "${CMAKE_SOURCE_DIR}/dependency/load" )

    if ( CMAKE_SYSTEM_NAME MATCHES "Linux" )
      set( load_SOURCE "${LOAD_SOURCE_DIR}/linux/memory.cc" "${LOAD_SOURCE_DIR}/linux/cpu.cc" )
    elseif ( CMAKE_SYSTEM_NAME MATCHES "Darwin" )
      set( load_SOURCE "${LOAD_SOURCE_DIR}/osx/memory.cc" "${LOAD_SOURCE_DIR}/osx/cpu.cc" )
    elseif ( CMAKE_SYSTEM_NAME MATCHES "FreeBSD" )
      set( load_SOURCE "${LOAD_SOURCE_DIR}/freebsd/memory.cc" "${LOAD_SOURCE_DIR}/freebsd/cpu.cc" )
    elseif ( CMAKE_SYSTEM_NAME MATCHES "OpenBSD" )
      set( load_SOURCE "${LOAD_SOURCE_DIR}/openbsd/memory.cc" "${LOAD_SOURCE_DIR}/openbsd/cpu.cc" )
      if ( CMAKE_SYSTEM_VERSION VERSION_LESS 5.7 )
        add_definitions( -DOPENBSD_WORKAROUND=1 )
      endif ( )
    elseif ( CMAKE_SYSTEM_NAME MATCHES "NetBSD" )
      set( load_SOURCE "${LOAD_SOURCE_DIR}/netbsd/memory.cc" "${LOAD_SOURCE_DIR}/netbsd/cpu.cc" )
    endif ( )

    if( ${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC )
        set_source_files_properties( ${load_SOURCE} PROPERTIES COMPILE_FLAGS "/w" )
    else ( )
        set_source_files_properties( ${load_SOURCE} PROPERTIES COMPILE_FLAGS "-w" )
    endif ( )

    message( STATUS "${Green}Found Load include at: ${load_INCLUDE}${Reset}" )
else ( )
    message( FATAL_ERROR "${Red}Failed to locate Load dependency.${Reset}" )
endif ( )
