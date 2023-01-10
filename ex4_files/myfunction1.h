
#ifndef __myfunc1_h
#define __myfunc1_h

#include "myutil.h"
#include "readBMP.h"

void initialize_pixel_sum(pixel_sum *sum);
void doConvolution(int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter, bool blur);
void initialize_pixel_sum(pixel_sum *sum);
static inline void assign_sum_to_pixel(pixel *current_pixel, pixel_sum sum, int kernelScale, bool blur);
static inline void sum_pixels_by_weight(pixel_sum *sum, pixel p, int weight);
static inline pixel applyKernel(int dim, pixel *src, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter, bool blur);
static inline pixel applyKernel1x3(int dim, pixel *src, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter, bool blur);
void charsToPixels(pixel* pixels);
void pixelsToChars(pixel* pixels);
void copyPixels(pixel* src, pixel* dst);


#endif

