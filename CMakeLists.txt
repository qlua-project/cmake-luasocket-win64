cmake_minimum_required( VERSION 3.30 )
project( luasocket C )

add_compile_options( /W4 )  # -Wall

#set( CMAKE_VERBOSE_MAKEFILE on )
#set( ALLOW_DUPLICATE_CUSTOM_TARGETS TRUE )
set ( LUASOCKET_DIR src CACHE PATH "Where to search LuaSocket sources." )

message ( ${CMAKE_C_FLAGS_RELEASE} )

set ( ENV{LUA_DIR} "externals/lua" )
find_package ( Lua REQUIRED )
message ( STATUS "Lua Version ${LUA_VERSION_STRING}" )
message ( STATUS "Lua Includes ${LUA_INCLUDE_DIR}" )
message ( STATUS "Lua Library ${LUA_LIBRARY}" )
message ( STATUS "Lua Libraries ${LUA_LIBRARIES}" )

include_directories( ${LUA_INCLUDE_DIR} )
add_compile_definitions(
        # push time elapsed during operation as the last return value
        #    LUASOCKET_DEBUG
        # https://learn.microsoft.com/en-us/cpp/c-runtime-library/security-features-in-the-crt
        # warning C4996: 'sprintf' => sprintf_s instead
            _CRT_SECURE_NO_WARNINGS
        # warning C4996: 'gethostbyaddr' => getnameinfo() or GetNameInfoW() instead
            _WINSOCK_DEPRECATED_NO_WARNINGS
        # LUASOCKET_INET_PTON
)

set ( SOCKET_CORE src/luasocket.c src/timeout.c src/buffer.c src/io.c src/auxiliar.c
        src/options.c src/inet.c src/except.c src/select.c src/tcp.c src/udp.c src/compat.c
        src/wsocket.c )

set ( MIME_CORE src/mime.c src/compat.c )  # src/compat.c


list( TRANSFORM SOCKET_CORE PREPEND "${LUASOCKET_DIR}/" )
list( TRANSFORM MIME_CORE PREPEND "${LUASOCKET_DIR}/" )

# https://cmake.org/cmake/help/latest/command/install.html
# ARCHIVE - Target artifacts of this kind include: Static libraries
# LIBRARY - Shared libraries, except DLLs
# RUNTIME - Executables, DLLs

add_library( socketcoredll MODULE ${SOCKET_CORE} )
target_link_libraries( socketcoredll ${LUA_LIBRARY} ws2_32.lib )
set_target_properties ( socketcoredll PROPERTIES OUTPUT_NAME core
        # ARCHIVE_OUTPUT_DIRECTORY socket
        # RUNTIME_OUTPUT_DIRECTORY socket
        LIBRARY_OUTPUT_DIRECTORY socket
)

add_library( mimedll MODULE ${MIME_CORE} )
target_link_libraries( mimedll ${LUA_LIBRARY} )
set_target_properties ( mimedll PROPERTIES OUTPUT_NAME core
        # ARCHIVE_OUTPUT_DIRECTORY mime
        # RUNTIME_OUTPUT_DIRECTORY mime
        LIBRARY_OUTPUT_DIRECTORY mime
)

install(TARGETS socketcoredll LIBRARY DESTINATION "bin/socket")
install(TARGETS mimedll LIBRARY DESTINATION "bin/mime" )
install ( FILES ${LUASOCKET_DIR}/src/http.lua DESTINATION "bin/socket" )
install ( FILES ${LUASOCKET_DIR}/src/url.lua DESTINATION "bin/socket" )
install ( FILES ${LUASOCKET_DIR}/src/tp.lua DESTINATION "bin/socket" )
install ( FILES ${LUASOCKET_DIR}/src/ftp.lua DESTINATION "bin/socket" )
install ( FILES ${LUASOCKET_DIR}/src/headers.lua DESTINATION "bin/socket" )
install ( FILES ${LUASOCKET_DIR}/src/smtp.lua DESTINATION "bin/socket" )
install ( FILES ${LUASOCKET_DIR}/src/ltn12.lua DESTINATION "bin" )
install ( FILES ${LUASOCKET_DIR}/src/socket.lua DESTINATION "bin" )
install ( FILES ${LUASOCKET_DIR}/src/mbox.lua DESTINATION "bin" )
install ( FILES ${LUASOCKET_DIR}/src/mime.lua DESTINATION "bin" )
