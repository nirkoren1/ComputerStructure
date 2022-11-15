#include "ex1.h"
#include <stdio.h>

int is_big_endian() {
	int i = 1;
    //looks only on the first byte
    char *p = (char*) &i;
    one_or_zero = p[0];
    return one_or_zero;
}
//int get_sign_magnitude(bitArray) {

//}

int main() {
	is_big_endian();
}
