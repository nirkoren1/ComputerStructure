#include <stdlib.h>
#include <stdbool.h>
#include "myfunction1.h"
#include "showBMP.h"
#include <stdio.h>
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
static void assign_sum_to_pixel(pixel *current_pixel, pixel_sum sum, int kernelScale) {

    // divide by kernel's weight
    sum.red = sum.red / kernelScale;
    sum.green = sum.green / kernelScale;
    sum.blue = sum.blue / kernelScale;

    // truncate each pixel's color values to match the range [0,255]
	current_pixel->red = (min(max(sum.red, 0), 255));
	current_pixel->green = (min(max(sum.green, 0), 255));
	current_pixel->blue = (min(max(sum.blue, 0), 255));
    return;
}

/*
* sum_pixels_by_weight - Sums pixel values, scaled by given weight
*/
static void sum_pixels_by_weight(pixel_sum *sum, pixel p, int weight) {
    sum->red += ((int) p.red) * weight;
    sum->green += ((int) p.green) * weight;
    sum->blue += ((int) p.blue) * weight;
    // sum->num++;
    return;
}

/*
 *  Applies kernel for pixel at (i,j)
 */
static pixel applyKernel(int dim, int i, int j, pixel *src, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {

    int ii, jj;
    int currRow, currCol;
    pixel_sum sum;
    pixel current_pixel;
    int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
    int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
    int min_row, min_col, max_row, max_col;
    pixel loop_pixel;

    initialize_pixel_sum(&sum);

    int lowerBoundII = i - 1;
    int lowerBoundJJ = j - 1;


//    int iiCounter = lowerBoundII * dim;
    int iiCounter;
    pixel *srcPtr = &(src[calcIndex(lowerBoundII, lowerBoundJJ, dim)]);
    for(ii = 0 ; ii <= 2 ; ii++) {
        for(jj = 0 ; jj <= 2 ; jj++) {

//            int kRow, kCol;
//
//            // compute row index in kernel
//            if (ii < i) {
//                kRow = 0;
//            } else if (ii > i) {
//                kRow = 2;
//            } else {
//                kRow = 1;
//            }
//
//            // compute column index in kernel
//            if (jj < j) {
//                kCol = 0;
//            } else if (jj > j) {
//                kCol = 2;
//            } else {
//                kCol = 1;
//            }

            // apply kernel on pixel at [ii,jj]
//			sum_pixels_by_weight(&sum, src[iiCounter + jj], kernel[kRow][kCol]);
            sum_pixels_by_weight(&sum, *srcPtr, kernel[ii][jj]);
            srcPtr++;
        }
        srcPtr += dim - 3;
//        iiCounter += dim;
    }

    if (filter) {
        // find min and max coordinates
        int upperBoundII = i + 1;
        int upperBoundJJ = j + 1;
        iiCounter = lowerBoundII * dim;
        srcPtr = &(src[calcIndex(lowerBoundII, lowerBoundJJ, dim)]);
        for(ii = lowerBoundII ; ii <= upperBoundII ; ii++) {
            for(jj = lowerBoundJJ ; jj <= upperBoundJJ ; jj++) {
                // check if smaller than min or higher than max and update
//				loop_pixel = src[iiCounter + jj];
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
//            iiCounter += dim;
            srcPtr += dim - 3;
        }
        // filter out min and max
        sum_pixels_by_weight(&sum, src[calcIndex(min_row, min_col, dim)], -1);
        sum_pixels_by_weight(&sum, src[calcIndex(max_row, max_col, dim)], -1);
    }

    // assign kernel's result to pixel at [i,j]
    assign_sum_to_pixel(&current_pixel, sum, kernelScale);
    return current_pixel;
}
static pixel applyKernel2(int dim, int i, int j, pixel *src, const pixel *srcRow1, const pixel *srcRow2, const pixel *srcRow3 , int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {

    int ii, jj;
    int currRow, currCol;
    pixel_sum sum;
    pixel current_pixel;
    int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
    int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
    int min_row, min_col, max_row, max_col;
    pixel loop_pixel;

    initialize_pixel_sum(&sum);

    int upperBoundII = i + 1;
    int upperBoundJJ = j + 1;
    int lowerBoundII = i - 1;
    int lowerBoundJJ = j - 1;


//    int iiCounter = lowerBoundII * dim;
    int iiCounter;
    sum_pixels_by_weight(&sum, *srcRow1, kernel[0][0]);
    sum_pixels_by_weight(&sum, *(srcRow1+1), kernel[0][1]);
    sum_pixels_by_weight(&sum, *(srcRow1+2), kernel[0][2]);
    sum_pixels_by_weight(&sum, *srcRow2, kernel[1][0]);
    sum_pixels_by_weight(&sum, *(srcRow2+1), kernel[1][1]);
    sum_pixels_by_weight(&sum, *(srcRow2+2), kernel[1][2]);
    sum_pixels_by_weight(&sum, *srcRow3, kernel[2][0]);
    sum_pixels_by_weight(&sum, *(srcRow3+1), kernel[2][1]);
    sum_pixels_by_weight(&sum, *(srcRow3+2), kernel[2][2]);

    if (filter) {
        // find min and max coordinates
        iiCounter = lowerBoundII * dim;
        pixel *srcPtr = &(src[calcIndex(lowerBoundII, lowerBoundJJ, dim)]);
        for(ii = lowerBoundII ; ii <= upperBoundII ; ii++) {
            for(jj = lowerBoundJJ ; jj <= upperBoundJJ ; jj++) {
                // check if smaller than min or higher than max and update
//				loop_pixel = src[iiCounter + jj];
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
//            iiCounter += dim;
            srcPtr += dim - 3;
        }
        // filter out min and max
        sum_pixels_by_weight(&sum, src[calcIndex(min_row, min_col, dim)], -1);
        sum_pixels_by_weight(&sum, src[calcIndex(max_row, max_col, dim)], -1);
    }

    // assign kernel's result to pixel at [i,j]
    assign_sum_to_pixel(&current_pixel, sum, kernelScale);
    return current_pixel;
}

static pixel applyKernel3x3(int dim, int i, int j, pixel *src, int ker1, int ker2, int ker3, int ker4, int ker5, int ker6, int ker7, int ker8, int ker9 , int kernelSize, int kernelScale, bool filter) {

    int ii, jj;
    int currRow, currCol;
    pixel_sum sum;
    pixel current_pixel;
    int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
    int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
    int min_row, min_col, max_row, max_col;
    pixel loop_pixel;

    initialize_pixel_sum(&sum);

    int lowerBoundII = i - 1;
    int lowerBoundJJ = j - 1;


//    int iiCounter = lowerBoundII * dim;
    int iiCounter;
    pixel *srcPtr = &(src[calcIndex(lowerBoundII, lowerBoundJJ, dim)]);
    sum_pixels_by_weight(&sum, *srcPtr, ker1);
    srcPtr++;
    sum_pixels_by_weight(&sum, *srcPtr, ker2);
    srcPtr++;
    sum_pixels_by_weight(&sum, *srcPtr, ker3);
    srcPtr += dim - 2;
    sum_pixels_by_weight(&sum, *srcPtr, ker4);
    srcPtr++;
    sum_pixels_by_weight(&sum, *srcPtr, ker5);
    srcPtr++;
    sum_pixels_by_weight(&sum, *srcPtr, ker6);
    srcPtr += dim - 2;
    sum_pixels_by_weight(&sum, *srcPtr, ker7);
    srcPtr++;
    sum_pixels_by_weight(&sum, *srcPtr, ker8);
    srcPtr++;
    sum_pixels_by_weight(&sum, *srcPtr, ker9);

    if (filter) {
        // find min and max coordinates
        int upperBoundII = i + 1;
        int upperBoundJJ = j + 1;
        iiCounter = lowerBoundII * dim;
        srcPtr = &(src[calcIndex(lowerBoundII, lowerBoundJJ, dim)]);
        for(ii = lowerBoundII ; ii <= upperBoundII ; ii++) {
            for(jj = lowerBoundJJ ; jj <= upperBoundJJ ; jj++) {
                // check if smaller than min or higher than max and update
//				loop_pixel = src[iiCounter + jj];
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
//            iiCounter += dim;
            srcPtr += dim - 3;
        }
        // filter out min and max
        sum_pixels_by_weight(&sum, src[calcIndex(min_row, min_col, dim)], -1);
        sum_pixels_by_weight(&sum, src[calcIndex(max_row, max_col, dim)], -1);
    }

    // assign kernel's result to pixel at [i,j]
    assign_sum_to_pixel(&current_pixel, sum, kernelScale);
    return current_pixel;
}
/*
* Apply the kernel over each pixel.
* Ignore pixels where the kernel exceeds bounds. These are pixels with row index smaller than kernelSize/2 and/or
* column index smaller than kernelSize/2
*/
void smooth(int dim, pixel *src, pixel *dst, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {

    int i, j;
    int upper_limit = dim - kernelSize / 2;
    int lower_limit = kernelSize / 2;
    int iDimCounter = lower_limit * dim;
    int leap = &(dst[iDimCounter + dim + lower_limit]) - &(dst[iDimCounter + upper_limit]);
    int size = sizeof(pixel);
    int sizeLeap = leap * size;

    // check if kernel is 3x3
//    if (kernelSize == 3) {
//
//    }

//    register int ker1 = kernel[0][0];
//    register int ker2 = kernel[0][1];
//    register int ker3 = kernel[0][2];
//    register int ker4 = kernel[1][0];
//    register int ker5 = kernel[1][1];
//    register int ker6 = kernel[1][2];
//    register int ker7 = kernel[2][0];
//    register int ker8 = kernel[2][1];
//    register int ker9 = kernel[2][2];


    pixel *current_pixel = &(dst[iDimCounter + lower_limit]);
    for (i = lower_limit ; i < upper_limit ; i++) {
        for (j =  lower_limit ; j < upper_limit ; j++) {
            *current_pixel = applyKernel(dim, i, j, src, kernelSize, kernel, kernelScale, filter);
//            *current_pixel = applyKernel3x3(dim, i, j, src, ker1, ker2, ker3, ker4, ker5, ker6, ker7, ker8, ker9, kernelSize, kernelScale, filter);
//            *current_pixel = applyKernel2(dim, i, j, src, srcPtrRow1, srcPtrRow2, srcPtrRow3, kernelSize, kernel, kernelScale, filter);
            current_pixel = (void *) ((char *) current_pixel + size);
        }
        current_pixel = (void *) ((char *) current_pixel + sizeLeap);
    }
}

void charsToPixels(Image *charsImg, pixel* pixels) {

    int row, col;
    for (row = 0 ; row < m ; row++) {
        for (col = 0 ; col < n ; col++) {

            pixels[row*n + col].red = image->data[3*row*n + 3*col];
            pixels[row*n + col].green = image->data[3*row*n + 3*col + 1];
            pixels[row*n + col].blue = image->data[3*row*n + 3*col + 2];
        }
    }
}

void pixelsToChars(pixel* pixels, Image *charsImg) {

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

void doConvolution(Image *image, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {

    pixel* pixelsImg = malloc(m*n*sizeof(pixel));
    pixel* backupOrg = malloc(m*n*sizeof(pixel));

    charsToPixels(image, pixelsImg);
    copyPixels(pixelsImg, backupOrg);

    smooth(m, backupOrg, pixelsImg, kernelSize, kernel, kernelScale, filter);

    pixelsToChars(pixelsImg, image);

    free(pixelsImg);
    free(backupOrg);
}

