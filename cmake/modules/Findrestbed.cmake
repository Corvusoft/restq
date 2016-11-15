# Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.

find_path( restbed_PROJECT CMakeLists.txt HINTS "${CMAKE_SOURCE_DIR}/dependency/restbed" )

if ( restbed_PROJECT )
    set( restbed_FOUND TRUE )

    include_directories( "${restbed_PROJECT}/source" )

    add_library( restbed OBJECT
        ${restbed_PROJECT}/source/corvusoft/restbed/byte.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/common.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/context_value.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/context_placeholder.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/context_placeholder_base.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/http.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/http.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/http_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/http_impl.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/uri.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/uri.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/uri_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/string.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/string.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/resource.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/resource.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/resource_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/rule.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/rule.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/service.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/service.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/service_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/service_impl.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/session.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/session.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/session_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/session_impl.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/session_manager.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/session_manager.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/web_socket.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/web_socket.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/web_socket_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/web_socket_impl.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/web_socket_message.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/web_socket_message.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/web_socket_message_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/web_socket_manager_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/web_socket_manager_impl.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/socket_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/socket_impl.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/rule_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/rule_engine_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/request.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/request.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/request_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/response.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/response.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/response_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/settings.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/settings.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/settings_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/ssl_settings.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/ssl_settings.cpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/ssl_settings_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/socket_impl.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/detail/socket_impl.cpp
     )

     set( RESTBED_ARTIFACTS
        ${restbed_PROJECT}/source/corvusoft/restbed/uri.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/byte.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/common.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/string.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/session.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/request.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/settings.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/response.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/status_code.hpp
        ${restbed_PROJECT}/source/corvusoft/restbed/ssl_settings.hpp
    )

    install( FILES ${RESTBED_ARTIFACTS} DESTINATION "${CMAKE_INSTALL_PREFIX}/include/corvusoft/restbed" )

    message( STATUS "${Green}Found Restbed include at: ${restbed_PROJECT}${Reset}" )
else ( )
    message( FATAL_ERROR "${Red}Failed to locate Restbed dependency.${Reset}" )
endif ( )
