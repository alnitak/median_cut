//#include <jni.h>
//#include <android/log.h>

#include <android/log.h>
#include "algo.h"

#ifdef __cplusplus
extern "C" {
#endif


void getPalette(int32_t numColors, uint8_t *imgBuffer, int64_t imgBufferLength, uint8_t *palette,
                double *percentages) {
    std::vector<P> source;
    int i = 0;
    while (i < imgBufferLength) {
        source.push_back(
                (P) {
                        imgBuffer[i],
                        imgBuffer[++i],
                        imgBuffer[++i],
                        imgBuffer[++i]
                }
        );
        i++;
    }
    std::vector<P> ret = median_cut_generate_palette(source, numColors);

    for (i = 0; i < numColors; ++i) {
//        __android_log_print(ANDROID_LOG_DEBUG, "median_cut",
//                            "result perc: %d  %f",
//                            i, ret[i].size);
        palette[i * 4    ] = ret[i].b;
        palette[i * 4 + 1] = ret[i].g;
        palette[i * 4 + 2] = ret[i].r;
        palette[i * 4 + 3] = ret[i].a;
        percentages[i] = ret[i].size;
    }
}




#ifdef __cplusplus
}
#endif