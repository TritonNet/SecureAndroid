#include <jni.h>
#include "string.h"

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

    result = env->NewStringUTF(msg);

    return result;
}