#include <stdio.h>
#include <stdlib.h>

long long calc(long long a, long long b, char op, long long *error);

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("ERROR_ARG\n");
        return 1;
    }

    long long a = atoll(argv[1]);
    char op = argv[2][0];
    long long b = atoll(argv[3]);

    long long error = 0;
    long long result = calc(a, b, op, &error);

    if (error == 1) {
        printf("ERROR_DIV_ZERO\n");
        return 1;
    }

    if (error == 2) {
        printf("ERROR_OPERATOR\n");
        return 1;
    }

    printf("%lld\n", result);
    return 0;
}