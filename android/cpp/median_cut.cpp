//#include <jni.h>
//#include <android/log.h>

#include "algo.h"

//#define JAVA(X) JNIEXPORT Java_com_bavagnoli_median_1cut_JNIWrapper_##X
//
//JavaVM  *javaVM;
//
//JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
//    javaVM = vm;
//    return JNI_VERSION_1_6;
//}





#ifdef __cplusplus
extern "C" {
#endif



void getPalette(int32_t numColors, uint8_t *imgBuffer, int64_t imgBufferLength, uint8_t *palette) {
    std::vector<P> source;
    for (int i=0; i<imgBufferLength; ++i) {
        source.push_back(
            (P) {
                    imgBuffer[i],
                    imgBuffer[++i],
                    imgBuffer[++i],
                    imgBuffer[++i]
            }
        );
    }
    std::vector<P> ret = median_cut_generate_palette(source, numColors);

    for (int i=0; i<numColors; i++) {
        palette[i*4]     = ret[i].b;
        palette[i*4 + 1] = ret[i].g;
        palette[i*4 + 2] = ret[i].r;
        palette[i*4 + 3] = ret[i].a;
    }

    bool b;
    b= true;
}




#ifdef __cplusplus
}
#endif