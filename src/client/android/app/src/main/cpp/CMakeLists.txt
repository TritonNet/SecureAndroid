cmake_minimum_required(VERSION 3.18.1)

set(projectName "poc")

project(${projectName})

add_library(
        ${projectName}
        SHARED

        poc.cpp )

# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -lcurl")

include_directories(/curl/)
include_directories(/openssl/)

target_include_directories(
        ${projectName}
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/curl/${ANDROID_ABI}/include/curl/
        ${CMAKE_CURRENT_SOURCE_DIR}/openssl/${ANDROID_ABI}/openssl/curl/
)

set(cmakeLibs_dir ${CMAKE_CURRENT_SOURCE_DIR}/../cmakeLibs/${ANDROID_ABI})

add_library(lib_crypto STATIC IMPORTED)
add_library(lib_ssl STATIC IMPORTED)
add_library(lib_curl STATIC IMPORTED)

set_target_properties(lib_crypto PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl/${ANDROID_ABI}/lib/libcrypto.a)
set_target_properties(lib_ssl PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl/${ANDROID_ABI}/lib/libssl.a)
set_target_properties(lib_curl PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/curl/${ANDROID_ABI}/lib/libcurl.a)

find_library(log-lib log)
find_package(ZLIB)

target_link_libraries(
        ${projectName}

        lib_crypto
        lib_ssl
        lib_curl

        ZLIB::ZLIB
        ${log-lib})
