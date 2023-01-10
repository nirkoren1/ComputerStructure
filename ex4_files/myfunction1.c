#include <stdlib.h>
#include <stdbool.h>
#include "myfunction1.h"
#include "showBMP.h"
/*
 * initialize_pixel_sum - Initializes all fields of sum to 0
 */
void initialize_pixel_sum(pixel_sum *sum) {
    sum->red = sum->green = sum->blue = 0;
    // sum->num = 0;
    return;
}

/*
 * assign_sum_to_pixel - Truncates pixel's new value to match the range [0,255]
 */
static inline void assign_sum_to_pixel(pixel *current_pixel, pixel_sum sum, float kernelScale, bool blur) {

    // divide by kernel's weight
    sum.red = sum.red * kernelScale;
    sum.green = sum.green * kernelScale;
    sum.blue = sum.blue * kernelScale;

    // truncate each pixel's color values to match the range [0,255]
    if (!blur) {
        current_pixel->red = (min(max(sum.red, 0), 255));
        current_pixel->green = (min(max(sum.green, 0), 255));
        current_pixel->blue = (min(max(sum.blue, 0), 255));
        return;
    }


    current_pixel->red = sum.red;
    current_pixel->green = sum.green;
    current_pixel->blue = sum.blue;
    return;
}

/*
* sum_pixels_by_weight - Sums pixel values, scaled by given weight
*/
static inline void sum_pixels_by_weight(pixel_sum *sum, pixel p, int weight) {
    if (weight == 1) {
        sum->red += p.red;
        sum->green += p.green;
        sum->blue += p.blue;
        return;
    }
    if (weight == -1) {
        sum->red -= p.red;
        sum->green -= p.green;
        sum->blue -= p.blue;
        return;
    };
    sum->red += p.red * weight;
    sum->green += p.green * weight;
    sum->blue += p.blue * weight;

    // sum->num++;
    return;
}

/*
 *  Applies kernel for pixel at (i,j)
 */
static inline pixel applyKernel(int dim, pixel *src, int kernelSize, int kernel[kernelSize][kernelSize], float kernelScale, bool filter, bool blur) {

    pixel_sum sum;
    pixel current_pixel;
    int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
    int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
    pixel loop_pixel;

    initialize_pixel_sum(&sum);

    int ii , jj;


    register pixel *srcPtr = src;
    for(ii = 0 ; ii <= 2 ; ii++) {
        for(jj = 0 ; jj <= 2 ; jj++) {
            // apply kernel on pixel at [ii,jj]
            sum_pixels_by_weight(&sum, *srcPtr, kernel[ii][jj]);
            srcPtr++;
        }
        srcPtr += dim - 3;
    }
    if (!filter) {
        // assign kernel's result to pixel at [i,j]
        assign_sum_to_pixel(&current_pixel, sum, kernelScale, blur);
        return current_pixel;
    }

    // find min and max coordinates
    srcPtr -= dim * 3;
    pixel *minPtr = srcPtr;
    pixel *maxPtr = srcPtr;
    for(ii = 0 ; ii <= 2 ; ii++) {
        for(jj = 0 ; jj <= 2 ; jj++) {
            // check if smaller than min or higher than max and update
            loop_pixel = *srcPtr;
            int intensity = ((int) loop_pixel.red) + ((int) loop_pixel.green) + ((int) loop_pixel.blue);
//            if (intensity <= min_intensity) {
//                min_intensity = intensity;
//                minPtr = srcPtr;
//            }
            intensity <= min_intensity ? (min_intensity = intensity, minPtr = srcPtr): 0;
            intensity > max_intensity ? (max_intensity = intensity, maxPtr = srcPtr): 0;
//            if (intensity > max_intensity) {
//                max_intensity = intensity;
//                maxPtr = srcPtr;
//            }

            srcPtr++;
        }
        srcPtr += dim - 3;
    }
    // filter out min and max
    sum_pixels_by_weight(&sum, *(minPtr), -1);
    sum_pixels_by_weight(&sum, *(maxPtr), -1);


    // assign kernel's result to pixel at [i,j]
    assign_sum_to_pixel(&current_pixel, sum, kernelScale, blur);
    return current_pixel;
}

static inline pixel applyKernel1x3(int dim, pixel *src, int kernelSize, int kernel[kernelSize][kernelSize], float kernelScale, bool filter, bool blur) {

    pixel_sum sum;
    pixel current_pixel;
    int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
    int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
    int min_row, min_col, max_row, max_col;
    pixel loop_pixel;

    initialize_pixel_sum(&sum);

    int ii , jj;


    register pixel *srcPtr = src;
    for(jj = 0 ; jj <= 2 ; jj++) {
        // apply kernel on pixel at [ii,jj]
        sum_pixels_by_weight(&sum, *srcPtr, kernel[1][jj]);
        srcPtr++;
    }

    if (!filter) {
        // assign kernel's result to pixel at [i,j]
        assign_sum_to_pixel(&current_pixel, sum, kernelScale, blur);
        return current_pixel;
    }

    // find min and max coordinates
    srcPtr -= 3;
    for(ii = 0 ; ii <= 2 ; ii++) {
        for(jj = 0 ; jj <= 2 ; jj++) {
            // check if smaller than min or higher than max and update
            loop_pixel = *srcPtr;
            int intensity = ((int) loop_pixel.red) + ((int) loop_pixel.green) + ((int) loop_pixel.blue);
            if (intensity <= min_intensity) {
                min_intensity = intensity;
                min_row = ii;
                min_col = jj;
            }
            if (intensity > max_intensity) {
                max_intensity = intensity;
                max_row = ii;
                max_col = jj;
            }
            srcPtr++;
        }
        srcPtr += dim - 3;
    }
    srcPtr -= dim * 3;
    // filter out min and max
    sum_pixels_by_weight(&sum, *(srcPtr + dim * min_row + min_col), -1);
    sum_pixels_by_weight(&sum, *(srcPtr + dim * max_row + max_col), -1);
    // assign kernel's result to pixel at [i,j]
    assign_sum_to_pixel(&current_pixel, sum, kernelScale, blur);
    return current_pixel;
}


/*
* Apply the kernel over each pixel.
* Ignore pixels where the kernel exceeds bounds. These are pixels with row index smaller than kernelSize/2 and/or
* column index smaller than kernelSize/2
*/
void smooth(int dim, pixel *src, pixel *dst, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter, bool blur) {

    int i, j;
    int upper_limit = dim - kernelSize / 2;
    int lower_limit = kernelSize / 2;
    int iDimCounter = lower_limit * dim;
    int leap = &(dst[iDimCounter + dim + lower_limit]) - &(dst[iDimCounter + upper_limit]);
    int size = sizeof(pixel);
    int sizeLeap = leap * size;
    float kernelScaleF = 1.0 / kernelScale;

    pixel *current_pixel = &(dst[iDimCounter + lower_limit]);
    // check if the kernel is 1x3 (zeros on above and below)
    if (kernel[0][0] != 0 || kernel[0][1] != 0 || kernel[0][2] != 0 || kernel[2][0] != 0 || kernel[2][1] != 0 || kernel[2][2] != 0) {
        pixel *srcPtr = &(src[calcIndex(lower_limit - 1, lower_limit - 1, dim)]);
        for (i = lower_limit; i < upper_limit; i++) {
            for (j = lower_limit; j < upper_limit; j++) {
                *current_pixel = applyKernel(dim,srcPtr, kernelSize, kernel, kernelScaleF, filter, blur);
                current_pixel++;
                srcPtr++;
            }
            current_pixel += leap;
            srcPtr += 2;
        }
    } else {
        pixel *srcPtr = &(src[calcIndex(lower_limit, lower_limit - 1, dim)]);
        for (i = lower_limit; i < upper_limit; i++) {
            for (j = lower_limit; j < upper_limit; j++) {
                *current_pixel = applyKernel1x3(dim, srcPtr, kernelSize, kernel, kernelScaleF, filter, blur);
                current_pixel++;
                srcPtr++;
            }
            current_pixel += leap;
            srcPtr += 2;
        }
    }
}

void charsToPixels(pixel* pixels) {

    int row, col;
    for (row = 0 ; row < m ; row++) {
        for (col = 0 ; col < n ; col++) {

            pixels[row*n + col].red = image->data[3*row*n + 3*col];
            pixels[row*n + col].green = image->data[3*row*n + 3*col + 1];
            pixels[row*n + col].blue = image->data[3*row*n + 3*col + 2];
        }
    }
}

void pixelsToChars(pixel* pixels) {

    int row, col;

    int row3N_counter = 0;
    int rowN_counter = 0;
    int n3 = 3 * n;

    for (row = 0 ; row < m ; row++) {
        int col_counter = 0;
        for (col = 0 ; col < n ; col++) {

            int index = row3N_counter + col_counter;
            int index2 = rowN_counter + col;

            image->data[index] = pixels[index2].red;
            image->data[index + 1] = pixels[index2].green;
            image->data[index + 2] = pixels[index2].blue;


            col_counter += 3;
        }
        row3N_counter += n3;
        rowN_counter += n;
    }
}

void copyPixels(pixel* src, pixel* dst) {

    int row, col;
    for (row = 0 ; row < m ; row++) {
        for (col = 0 ; col < n ; col++) {

            dst[row*n + col].red = src[row*n + col].red;
            dst[row*n + col].green = src[row*n + col].green;
            dst[row*n + col].blue = src[row*n + col].blue;
        }
    }
}

void doConvolution(int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter, bool blur) {

    pixel* pixelsImg = malloc(m*n*sizeof(pixel));
    pixel* backupOrg = malloc(m*n*sizeof(pixel));

    charsToPixels(pixelsImg);
    copyPixels(pixelsImg, backupOrg);

    smooth(m, backupOrg, pixelsImg, kernelSize, kernel, kernelScale, filter, blur);

    pixelsToChars(pixelsImg);

    free(pixelsImg);
    free(backupOrg);
}

