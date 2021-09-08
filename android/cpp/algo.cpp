//
// Created by deimos on 08/09/21.
//

// From
// https://indiegamedev.net/2020/01/17/median-cut-with-floyd-steinberg-dithering-in-c/


#include "algo.h"


bool operator==(const P& lhs, const P& rhs)
{
    return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a;
}

bool red_comp(const P& a, const P& b)
{
    return a.r < b.r;
}

bool green_comp(const P& a, const P& b)
{
    return a.g < b.g;
}

bool blue_comp(const P& a, const P& b)
{
    return a.b < b.b;
}

bool alpha_comp(const P& a, const P& b)
{
    return a.a < b.a;
}

void determine_primary_color_and_sort_box(std::vector<P>& box, std::uint8_t& redRange, std::uint8_t& greenRange, std::uint8_t& blueRange, std::uint8_t& alphaRange)
{
    redRange = (*std::max_element(box.begin(), box.end(), red_comp)).r - (*std::min_element(box.begin(), box.end(), red_comp)).r;
    greenRange = (*std::max_element(box.begin(), box.end(), green_comp)).g - (*std::min_element(box.begin(), box.end(), green_comp)).g;
    blueRange = (*std::max_element(box.begin(), box.end(), blue_comp)).b - (*std::min_element(box.begin(), box.end(), blue_comp)).b;
    alphaRange = (*std::max_element(box.begin(), box.end(), alpha_comp)).a - (*std::min_element(box.begin(), box.end(), alpha_comp)).a;

    if(redRange >= greenRange && redRange >= blueRange && redRange >= alphaRange)
    {
        std::sort(box.begin(), box.end(), red_comp);
    }
    else if(greenRange >= redRange && greenRange >= blueRange && greenRange >= alphaRange)
    {
        std::sort(box.begin(), box.end(), green_comp);
    }
    else if(blueRange >= redRange && blueRange >= greenRange && blueRange >= alphaRange)
    {
        std::sort(box.begin(), box.end(), blue_comp);
    }
    else
    {
        std::sort(box.begin(), box.end(), alpha_comp);
    }
}


std::vector<P> median_cut_generate_palette(const std::vector<P>& source, const std::uint_fast32_t numColors)
{
    typedef std::vector<P> Box;
    typedef std::pair<std::uint8_t,Box> RangeBox;

    std::vector<RangeBox> boxes;
    Box init = source;
    boxes.push_back(RangeBox(0,init));

    while(boxes.size() < numColors)
    {
        /* for each box, sort the boxes pixels according to the colour it has the most range in */
        for(RangeBox& boxData : boxes)
        {
            std::uint8_t redRange;
            std::uint8_t greenRange;
            std::uint8_t blueRange;
            std::uint8_t alphaRange;
            if(std::get<0>(boxData) == 0)
            {
                determine_primary_color_and_sort_box(std::get<1>(boxData), redRange, greenRange, blueRange, alphaRange);
                if(redRange >= greenRange && redRange >= blueRange && redRange >= alphaRange)
                {
                    std::get<0>(boxData) = redRange;
                }
                else if(greenRange >= redRange && greenRange >= blueRange && greenRange >= alphaRange)
                {
                    std::get<0>(boxData) = greenRange;
                }
                else if(blueRange >= redRange && blueRange >= greenRange && blueRange >= alphaRange)
                {
                    std::get<0>(boxData) = blueRange;
                }
                else
                {
                    std::get<0>(boxData) = alphaRange;
                }
            }
        }

        std::sort(boxes.begin(), boxes.end(), [](const RangeBox& a, const RangeBox& b)
        {
            return std::get<0>(a) < std::get<0>(b);
        });

        std::vector<RangeBox>::iterator itr = std::prev(boxes.end());
        Box biggestBox = std::get<1>(*itr);
        boxes.erase(itr);

        // the box is sorted already, so split at median
        Box splitA(biggestBox.begin(), biggestBox.begin() + biggestBox.size() / 2);
        Box splitB(biggestBox.begin() + biggestBox.size() / 2, biggestBox.end());

        boxes.push_back(RangeBox(0, splitA));
        boxes.push_back(RangeBox(0, splitB));
    }

    // each box in boxes can be averaged to determine the colour
    std::vector<P> palette;
    for(const RangeBox& boxData : boxes)
    {
        Box box = std::get<1>(boxData);
        std::uint_fast32_t redAccum = 0;
        std::uint_fast32_t greenAccum = 0;
        std::uint_fast32_t blueAccum = 0;
        std::uint_fast32_t alphaAccum = 0;
        std::for_each(box.begin(),box.end(),[&](const P& p)
        {
            redAccum += p.r;
            greenAccum += p.g;
            blueAccum += p.b;
            alphaAccum += p.a;
        });
        redAccum /= static_cast<std::uint_fast32_t>(box.size());
        greenAccum /= static_cast<std::uint_fast32_t>(box.size());
        blueAccum /= static_cast<std::uint_fast32_t>(box.size());
        alphaAccum /= static_cast<std::uint_fast32_t>(box.size());

        palette.push_back(
            {
                static_cast<std::uint8_t>(std::min<std::uint8_t>(blueAccum, 255u)),
                static_cast<std::uint8_t>(std::min<std::uint8_t>(greenAccum, 255u)),
                static_cast<std::uint8_t>(std::min<std::uint8_t>(redAccum, 255u)),
                static_cast<std::uint8_t>(std::min<std::uint8_t>(alphaAccum, 255u))
            });
    }
    return palette;
}