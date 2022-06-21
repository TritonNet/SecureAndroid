cmake_minimum_required(VERSION 3.18.1)

set(projectName "poc")

project(${projectName})

add_library(
        ${projectName}
        SHARED

        poc.cpp )

include_directories(/curl/)
include_directories(/openssl/)

set(cmakeLibs_dir ${CMAKE_CURRENT_SOURCE_DIR}/../cmakeLibs/${ANDROID_ABI}/)

add_library(crypto STATIC IMPORTED)
add_library(ssl STATIC IMPORTED)
add_library(curl STATIC IMPORTED)

set_target_properties(crypto PROPERTIES IMPORTED_LOCATION ${cmakeLibs_dir}/libcrypto.a)
set_target_properties(ssl PROPERTIES IMPORTED_LOCATION ${cmakeLibs_dir}/libssl.a)
set_target_properties(curl PROPERTIES IMPORTED_LOCATION ${cmakeLibs_dir}/libcurl.a)

find_library(log-lib log)
find_package(ZLIB)


target_link_libraries(
        ${projectName}

        crypto
        ssl
        curl
        ZLIB::ZLIB
        ${log-lib})
