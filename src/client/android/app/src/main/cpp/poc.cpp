#include <jni.h>
#include "string.h"
#include <iostream>
#include <string>
#include "curl/arm64-v8a/include/curl/curl.h"

static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}

std::string CallAAPI()
{
    CURL *curl;
    CURLcode res;
    std::string readBuffer;

    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "https://192.168.1.16:44375/api/service/ping");
        curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L) ;
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0);

//        curl_easy_setopt( c_url, CURLOPT_SSLKEYTYPE, _( "PEM" ) );
//        curl_easy_setopt( c_url, CURLOPT_SSLKEY, _( "path\\key.pem" ) );
//        curl_easy_setopt( c_url, CURLOPT_CAINFO, _( "path\\ca.pem" ) );

        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
    }

    return readBuffer;
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_tritonnet_secureandroid_poc_MainActivity_getResponse(
        JNIEnv *env,
        jobject thiz,
        jstring request)
{
    const char *name = env->GetStringUTFChars(request, nullptr);
    char msg[60] = "Helloxx ";
    jstring result;

    strcat(msg, name);
    env->ReleaseStringUTFChars(request, name);

    const auto apiResponse = CallAAPI();

    result = env->NewStringUTF(apiResponse.c_str());

    return result;
}
