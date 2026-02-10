cmake_minimum_required( VERSION 3.30 )
project( luasocket C )

#set( CMAKE_VERBOSE_MAKEFILE on )
#set( ALLOW_DUPLICATE_CUSTOM_TARGETS TRUE )

add_compile_options( /W4 )  # -Wall
message ( ${CMAKE_C_FLAGS_RELEASE} )

set ( LUASOCKET_DIR src CACHE PATH "Where to search LuaSocket sources." )

set ( ENV{LUA_DIR} "${PROJECT_SOURCE_DIR}/externals/lua" )
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

set ( SOCKET_INC src/socket.h src/timeout.h src/buffer.h src/io.h src/wsocket.h )

set ( SOCKET_CORE src/luasocket.c src/timeout.c src/buffer.c src/io.c src/auxiliar.c
        src/options.c src/inet.c src/except.c src/select.c src/tcp.c src/udp.c src/compat.c
        src/wsocket.c )

set ( MIME_CORE src/mime.c src/compat.c )  # src/compat.c


list( TRANSFORM SOCKET_INC PREPEND "${LUASOCKET_DIR}/" )
list( TRANSFORM SOCKET_CORE PREPEND "${LUASOCKET_DIR}/" )
list( TRANSFORM MIME_CORE PREPEND "${LUASOCKET_DIR}/" )

# https://cmake.org/cmake/help/latest/command/install.html
# ARCHIVE - Target artifacts of this kind include: Static libraries
# LIBRARY - Shared libraries, except DLLs
# RUNTIME - Executables, DLLs

# Target       File Type          Output Directory
# STATIC  .lib (Static Library)   ARCHIVE
# SHARED  .dll (The Binary)       RUNTIME
# SHARED  .lib (Import Library)   ARCHIVE
# MODULE  .dll (The Plugin)       LIBRARY (usually) or RUNTIME

add_library( socketcoredll SHARED ${SOCKET_CORE} "luasocket.def" )
target_link_libraries( socketcoredll ${LUA_LIBRARY} ws2_32 )
set_target_properties ( socketcoredll PROPERTIES OUTPUT_NAME core
        ARCHIVE_OUTPUT_NAME luasocket
        # ARCHIVE_OUTPUT_DIRECTORY socket
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/socket"
        # LIBRARY_OUTPUT_DIRECTORY socket
        PUBLIC_HEADER "${SOCKET_INC}"
)

add_library( mimedll MODULE ${MIME_CORE} )
target_link_libraries( mimedll ${LUA_LIBRARY} )
set_target_properties ( mimedll PROPERTIES OUTPUT_NAME core
        # ARCHIVE_OUTPUT_DIRECTORY mime
        # RUNTIME_OUTPUT_DIRECTORY mime
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/mime"
)

install ( TARGETS socketcoredll RUNTIME DESTINATION "bin/socket"
        ARCHIVE DESTINATION "lib"
        PUBLIC_HEADER DESTINATION "include"
)
install ( TARGETS mimedll LIBRARY DESTINATION "bin/mime" )

set ( SOCKET_FILES http.lua url.lua headers.lua ftp.lua smtp.lua tp.lua  )
set ( BIN_FILES    socket.lua mime.lua mbox.lua ltn12.lua  )
list ( TRANSFORM SOCKET_FILES PREPEND "${LUASOCKET_DIR}/src/" )
list ( TRANSFORM BIN_FILES    PREPEND "${LUASOCKET_DIR}/src/" )
install ( FILES ${SOCKET_FILES} DESTINATION "bin/socket" )
install ( FILES ${BIN_FILES}    DESTINATION "bin" )
