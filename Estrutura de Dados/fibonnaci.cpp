#include <iostream>
using namespace std;

int fibonacci_recursivo(unsigned int n){
    if (n == 0) return 0;
    if (n == 1) return 1;
    return fibonacci_recursivo(n-1) + fibonacci_recursivo(n-2);
}

int fibonacci_memoization(unsigned int n){
    int *vector = (int *) malloc(n * sizeof(int));
    vector[0] = 0;
    vector[1] = 1;
    for (unsigned int i = 2; i < n; i++){
        vector[i] = vector[i - 1] + vector[i - 2];
    }
    return vector[n - 1] + vector[n - 2];
}

int main(void){

    unsigned int n = 10;
    cout << fibonacci_memoization(n) << " - " << fibonacci_recursivo(n) << endl;
    return 0;
}