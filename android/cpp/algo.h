//
// Created by deimos on 08/09/21.
//

#include <vector>
#include <stdio.h>
#include <stdlib.h>

#ifndef ANDROID_ALGO_H
#define ANDROID_ALGO_H

struct P
{
    std::uint8_t b;
    std::uint8_t g;
    std::uint8_t r;
    std::uint8_t a;
};

std::vector<P> median_cut_generate_palette(const std::vector<P>& source, const std::uint_fast32_t numColors);


#endif //ANDROID_ALGO_H
