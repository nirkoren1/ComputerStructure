// 316443902 nir koren
#include "ex1.h"

int is_big_endian() {
//    This function creating int var with value 1 which will be 0x00000001 if big endian
//    than we look on the first byte which is 0x01 with the char datatype if we get 0x01 than big endian else we get
//    0x00 small endian
	int i = 1;
    //looks only on the first byte
    char *p = (char*) &i;
    int one_or_zero = p[0];
//    one_or_zero is 1 so the first byte is storing the 1 therefor little endian, if 0 than big endian
    return 1 - one_or_zero;
}

int get_sign_magnitude(bool bitArray[8]) {
//    Here I get the sign represented by the msb and sum all the bits with loop that doing powers of 2, then multiply
//    by -1 if the msb sign is 1
    int len = sizeof(bitArray) / sizeof(bitArray[0]);
    bool sign = bitArray[len - 1];
    int sum = 0;
    int i;
    for (i = 0; i < len - 1; ++i) {
       if (bitArray[i]) {
           int addToSum = 1;
           int j;
           //doing 2^i with shift
           addToSum = addToSum << i;
           sum += addToSum;
       }
    }
    if (sign) {
        sum *= -1;
    }
    return sum;
}

int get_two_comp(bool bitArray[8]) {
//    summing all the bits with the power of 2, the last bit is -2^8
    int len = sizeof(bitArray) / sizeof(bitArray[0]);
    int sum = 0;
    int i;
    for (i = 0; i < len - 1; ++i) {
        if (bitArray[i]) {
           int addToSum = 1;
           int j;
           //doing 2^i with shift
           addToSum = addToSum << i;
           sum += addToSum;
       }
    }
    if (bitArray[len - 1]) {
        int addToSum = 1;
        int j;
        for (j = 0; j < len - 1; ++j) {
           addToSum *= 2;
        }
        sum -= addToSum;
   }
    return sum;
}