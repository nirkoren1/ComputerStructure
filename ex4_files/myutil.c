
/* Compute min and max of two integers, respectively */
//int min(int a, int b) { return (a < b ? a : b); }
//int max(int a, int b) { return (a > b ? a : b); }

int max(int a, int b) {
    int c = a - b;
    int k = (c >> 31) & 0x1;
    int max = a - k * c;
    return max;
}

int min(int a, int b) {
    int c = a - b;
    int k = (c >> 31) & 0x1;
    int min = b + k * c;
    return min;
}

int calcIndex(int i, int j, int n) {
	return ((i)*(n)+(j));
}


