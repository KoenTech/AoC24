#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 65536

uint32_t getmax(u_int32_t* v, size_t count);

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE* file = fopen(argv[1], "r");
    if (file == NULL) {
        fprintf(stderr, "Error: could not open file %s\n", argv[1]);
        return 1;
    }

    uint32_t* left = (uint32_t*)malloc(BUF_SIZE * sizeof(uint32_t));
    uint32_t* right = (uint32_t*)malloc(BUF_SIZE * sizeof(uint32_t));

    size_t rows = 0;
    while (fscanf(file, "%u   %u\n", &left[rows], &right[rows]) == 2 && rows < BUF_SIZE) {
        rows++;
    }
    
    fclose(file);

    uint32_t* cmap = (uint32_t*)calloc(getmax(right, rows), sizeof(uint32_t));

    for (size_t i = 0; i < rows; i++) {
        cmap[right[i]]++;
    }

    uint32_t sum = 0;

    for (size_t i = 0; i < rows; i++) {
        sum += left[i] * cmap[left[i]];
    }

    free(left);
    free(right);
    free(cmap);

    printf("Sum: %u\n", sum);
    return 0;
}

uint32_t getmax(u_int32_t* v, size_t count) {
    uint32_t max = v[0];
    for (size_t i = 1; i < count; i++) {
        if (v[i] > max) {
            max = v[i];
        }
    }
    return max;
}