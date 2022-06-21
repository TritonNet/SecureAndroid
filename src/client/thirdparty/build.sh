#!/bin/bash
set -e

# DIR_CURRENT=$(dirname $BASH_SOURCE)
DIR_CURRENT="$(cd "$(dirname -- "$1")" >/dev/null; pwd -P)/$(basename -- "$1")"

OPENSSL_PATH="$DIR_CURRENT/openssl"
CURL_PATH="$DIR_CURRENT/curl"

BUILD_PATH="$DIR_CURRENT/build"
BUILD_PATH_OPENSSL=$BUILD_PATH/openssl
BUILD_PATH_CURL=$BUILD_PATH/curl

OUTPUT_PATH_ARM64V8A=$BUILD_PATH/arm64-v8a

PROJECT_PATH=../android/app/src/main
PROJECT_LIB_PATH=$PROJECT_PATH/cmakeLibs

MIN_SDK_VERSION=29
HOST_TAG=linux-x86_64

function check_ndk_root()
{
	if [ -z "$ANDROID_NDK_ROOT" ]
	then
		echo "ANDROID_NDK_ROOT environment variable is not set."
		exit 1
	fi
}

function create_build_dir()
{
	mkdir -p $BUILD_PATH_CURL >/dev/null 2>&1
	mkdir -p $BUILD_PATH_OPENSSL >/dev/null 2>&1
	mkdir -p $OUTPUT_PATH_ARM64V8A >/dev/null 2>&1
}

function build_openssl()
{
	pushd $BUILD_PATH_OPENSSL
	# https://github.com/openssl/openssl/blob/master/NOTES-ANDROID.md
	# export ANDROID_NDK_ROOT=/usr/share/android-sdk/ndk/24.0.8215888
	PATH=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG/bin:$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/$HOST_TAG/bin:$PATH

	dos2unix $OPENSSL_PATH/Configure

	# android-arm64, android-arm, android-x86 and android-x86_64

	#$OPENSSL_PATH/Configure android-arm64 -D__ANDROID_API__=$ANDROID_API

	$OPENSSL_PATH/Configure android-arm64 --prefix=$OUTPUT_PATH_ARM64V8A
	make
	make install
	popd
}

function build_curl()
{
	pushd $BUILD_PATH_CURL

	#export TARGET_HOST=aarch64-linux-android
	export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG
	PATH=$TOOLCHAIN/bin:$PATH

	export AR=$TOOLCHAIN/bin/llvm-ar
	export AS=$TOOLCHAIN/bin/llvm-as

	export CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
	export CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++

	export LD=$TOOLCHAIN/bin/$TARGET_HOST-ld
	export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
	export STRIP=$TOOLCHAIN/bin/llvm-strip

	export SSL_DIR=$OUTPUT_PATH_ARM64V8A

	autoreconf -i $CURL_PATH/

	$CURL_PATH/configure --host=$TARGET_HOST \
						 --target=$TARGET_HOST \
						 --prefix=$OUTPUT_PATH_ARM64V8A \
						 --with-ssl=$SSL_DIR \
						 --disable-shared

	make
	make install

	#cp $DIR_CURRENT/build/openssl/lib/libcrypto.so $TOOLCHAIN/sysroot/usr/lib
	#cp $DIR_CURRENT/build/openssl/lib/libssl.so $TOOLCHAIN/sysroot/usr/lib
	#mkdir $TOOLCHAIN/sysroot/usr/include/openssl
	#cp $DIR_CURRENT/build/openssl/lib/include/openssl/* $TOOLCHAIN/sysroot/usr/include/openssl

	# --with-pic --disable-shared 
	#$CURL_PATH/configure --host $HOST --with-openssl="$TOOLCHAIN/sysroot/usr"
	popd
}

function copy_output_files()
{
	cp $OUTPUT_PATH_ARM64V8A/lib/libcurl.a $PROJECT_LIB_PATH/arm64-v8a/
	cp $OUTPUT_PATH_ARM64V8A/lib/libssl.a $PROJECT_LIB_PATH/arm64-v8a/
	cp $OUTPUT_PATH_ARM64V8A/lib/libcrypto.a $PROJECT_LIB_PATH/arm64-v8a/

	cp -r $OUTPUT_PATH_ARM64V8A/include/* $PROJECT_PATH/cpp/
}

function main()
{
	check_ndk_root
	create_build_dir
	build_openssl
	#build_curl
	#copy_output_files
	echo "Done"
}

main