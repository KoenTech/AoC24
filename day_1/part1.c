#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 65536

size_t get_min(size_t count, uint32_t* values, uint32_t* min_val);

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

    uint32_t sum = 0;
    for (size_t i = rows; i > 0; i--) {
        uint32_t min_val_left, min_val_right;
        size_t min_index_left = get_min(i, left, &min_val_left);
        size_t min_index_right = get_min(i, right, &min_val_right);

        sum += abs((int32_t)((int32_t)min_val_left - (int32_t)min_val_right));

        memmove(&left[min_index_left], &left[min_index_left + 1], (i - min_index_left - 1) * sizeof(uint32_t));
        memmove(&right[min_index_right], &right[min_index_right + 1], (i - min_index_right - 1) * sizeof(uint32_t));
    }

    free(left);
    free(right);

    printf("Sum: %u\n", sum);
    return 0;
}

size_t get_min(size_t count, uint32_t* values, uint32_t* min_val) {
    uint32_t min = values[0];
    size_t min_index = 0;
    for (size_t i = 1; i < count; i++) {
        if (values[i] < min) {
            min = values[i];
            min_index = i;
        }
    }
    *min_val = min;
    return min_index;
}
