#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define CHANGE_FUNCTION 128 // Valor que altera o tipo de multiplicação, 128 foi o melhor valor encontrado após uma série de testes
#define RAND_VALUE 1001

int compara_resultado(int n, int** matrizA, int** matrizB);

int** tradicional(int n, int** matrizA, int** matrizB);
int** initialize_matrix(int** matrix, int n);
void free_matrix(int** matrix, int n);
int** strassen(int n, int** matrizA, int** matrizB);

int** matrix_addition(int n, int** matrizA, int** matrizB, int matrizA_linha, int matrizA_coluna, int matrizB_linha, int matrizB_coluna);
int** matrix_subtraction(int n, int** matrizA, int** matrizB, int matrizA_linha, int matrizA_coluna, int matrizB_linha, int matrizB_coluna);



int main(void){
    srand(time(0)); // Sempre gera valores aleatórios
    
    int n;
    scanf("%d", &n);
    
    int** matrizA;
    int** matrizB;
    int** matrizC;

    matrizA = initialize_matrix(matrizA, n);
    matrizB = initialize_matrix(matrizB, n);
    matrizC = initialize_matrix(matrizC, n);

    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            int signal = rand() % 2;
            if (signal == 0){
                matrizA[i][j] = rand() % RAND_VALUE;
                matrizB[i][j] = rand() % RAND_VALUE;
            } else {
                matrizA[i][j] = (rand() % RAND_VALUE)*(-1);
                matrizB[i][j] = (rand() % RAND_VALUE)*(-1);
            }
           
        }
    }

    int resultado = compara_resultado(n, matrizA, matrizB);

    if (resultado) printf("Resultado correto!\n");
    else printf("Resultado incorreto!\n");
   
    return 0;
}

// Multiplicação tradicional que leva O(n^3)
int** tradicional(int n, int** matrizA, int** matrizB){
    int** result = initialize_matrix(result, n);
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            result[i][j] = 0;
            for (int k = 0; k < n; k++){
                result[i][j] += matrizA[i][k] * matrizB[k][j];
            }
        }
    }
    return result;
}

// Aloca espaço dinamicamente de uma matrix de tamanho NxN
int** initialize_matrix(int** matrix, int n){
    matrix = (int**) malloc(n * sizeof(int *));
    if (matrix == NULL){
        printf("Memory allocation failed. \n");
        exit(0);
    }
    for (int i = 0; i < n; i++){
        matrix[i] = (int*) malloc(n * sizeof(int));
        if (matrix[i] == NULL){
            printf("Memory allocation failed. \n");
            exit(0);
        }
    }
    return matrix;
}

// desaloca a matrix NxN
void free_matrix(int** matrix, int n){
    for (int i = 0; i < n; i++){
        int* currentIntPtr = matrix[i];
        free(currentIntPtr);
    }
    free(matrix);
}

// Multiplicação de strassen
int** strassen(int n, int** matrizA, int** matrizB){

    if (n <= CHANGE_FUNCTION){
        return tradicional(n, matrizA, matrizB);
    } 
    
    int k = n/2;

    int **m1, **m2, **m3, **m4, **m5, **m6, **m7;
    
    int **auxiliar_1, **auxiliar_2, **auxiliar_3;

    auxiliar_1 = matrix_addition(k, matrizA, matrizA, 0, 0, k, k);
    auxiliar_2 = matrix_addition(k, matrizB, matrizB, 0, 0, k, k);
    m1 = strassen(k, auxiliar_1, auxiliar_2);
    free_matrix(auxiliar_1, k);
    free_matrix(auxiliar_2, k);

    auxiliar_1 = matrix_addition(k, matrizA, matrizA, k, 0, k, k);
    m2 = strassen(k, auxiliar_1, matrizB);
    free_matrix(auxiliar_1, k);

    auxiliar_1 = matrix_subtraction(k, matrizB, matrizB, 0, k, k, k);
    m3 = strassen(k, matrizA, auxiliar_1);
    free_matrix(auxiliar_1, k);
    
    auxiliar_1 = initialize_matrix(auxiliar_1, k);
    for (int i = 0; i < k; i++){
        for(int j = 0 ; j < k; j++){
            auxiliar_1[i][j] = matrizA[i + k][j + k];
        }
    }
    auxiliar_2 = matrix_subtraction(k, matrizB, matrizB, k, 0, 0, 0);
    m4 = strassen(k, auxiliar_1, auxiliar_2);
    free_matrix(auxiliar_2, k);

    for (int i = 0; i < k; i++){
        for(int j = 0 ; j < k; j++){
            auxiliar_1[i][j] = matrizB[i + k][j + k];
        }
    }
    auxiliar_2 = matrix_addition(k, matrizA, matrizA, 0, 0, 0, k);
    m5 = strassen(k, auxiliar_2, auxiliar_1);
    free_matrix(auxiliar_1, k);
    free_matrix(auxiliar_2, k);

    auxiliar_1 = matrix_subtraction(k, matrizA, matrizA, k, 0, 0, 0);
    auxiliar_2 = matrix_addition(k, matrizB, matrizB, 0, 0, 0, k);
    m6 = strassen(k, auxiliar_1, auxiliar_2);
    free_matrix(auxiliar_1, k);
    free_matrix(auxiliar_2, k);

    auxiliar_1 = matrix_subtraction(k, matrizA, matrizA, 0, k, k, k);
    auxiliar_2 = matrix_addition(k, matrizB, matrizB, k, 0, k, k);
    m7 = strassen(k, auxiliar_1, auxiliar_2);
    free_matrix(auxiliar_1, k);
    free_matrix(auxiliar_2, k);
    
    int** result = initialize_matrix(result, n);

    auxiliar_1 = matrix_addition(k, m1, m7, 0, 0, 0, 0);
    auxiliar_2 = matrix_subtraction(k, m4, m5, 0, 0, 0, 0);
    auxiliar_3 = matrix_addition(k, auxiliar_1, auxiliar_2, 0, 0, 0, 0);
    free_matrix(auxiliar_1, k);
    free_matrix(auxiliar_2, k);

    for (int i = 0; i < k; i++){
        for (int j = 0; j < k; j++){
            result[i][j] = auxiliar_3[i][j];
        }
    }
    free_matrix(m7, k);
    free_matrix(auxiliar_3, k);

    auxiliar_1 = matrix_addition(k, m3, m5, 0, 0, 0, 0);

    for (int i = 0; i < k; i++){
        for (int j = 0; j < k; j++){
            result[i][j + k] = auxiliar_1[i][j];
        }
    }
    free_matrix(auxiliar_1, k);
    free_matrix(m5, k);
    
    auxiliar_1 = matrix_addition(k, m2, m4, 0, 0, 0, 0);

    for (int i = 0; i < k; i++){
        for (int j = 0; j < k; j++){
            result[i + k][j] = auxiliar_1[i][j];
        }
    }
    free_matrix(auxiliar_1, k);
    free_matrix(m4, k);
    

    auxiliar_1 = matrix_subtraction(k, m1, m2, 0, 0, 0, 0);
    auxiliar_2 = matrix_addition(k, m3, m6, 0, 0, 0, 0);
    auxiliar_3 = matrix_addition(k, auxiliar_1, auxiliar_2, 0, 0, 0, 0);
    
    free_matrix(auxiliar_1, k);
    free_matrix(auxiliar_2, k);
    free_matrix(m1, k);
    free_matrix(m2, k);
    free_matrix(m3, k);
    free_matrix(m6, k);

    for (int i = 0; i < k; i++){
        for (int j = 0; j < k; j++){
            result[i + k][j + k] = auxiliar_3[i][j];
        }
    }

    free_matrix(auxiliar_3, k);
    
    return result;
}

// Soma de matrizes que leva em consideração os offsets das linhas e colunas das matrizes
int** matrix_addition(int n, int** matrizA, int** matrizB, int matrizA_linha, int matrizA_coluna, int matrizB_linha, int matrizB_coluna){
    int** result = initialize_matrix(result, n);

    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            result[i][j] = matrizA[i + matrizA_linha][j + matrizA_coluna] + matrizB[i + matrizB_linha][j + matrizB_coluna];
        }
    }

    return result;
}

// Subtração de matrizes que leva em consideração os offsets das linhas e colunas das matrizes
int** matrix_subtraction(int n, int** matrizA, int** matrizB, int matrizA_linha, int matrizA_coluna, int matrizB_linha, int matrizB_coluna){
    int** result = initialize_matrix(result, n);

    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            result[i][j] = matrizA[i + matrizA_linha][j + matrizA_coluna] - matrizB[i + matrizB_linha][j + matrizB_coluna];
        }
    }

    return result;
}

// Matriz que compara o resultado gerado pelas multiplicações
int compara_resultado(int n, int** matrizA, int** matrizB){

    int** resul_tradicional = initialize_matrix(resul_tradicional, n);
    int** resul_strassen = initialize_matrix(resul_strassen, n);
    
    double time_spent = 0.0;
    clock_t begin = clock();
   
    resul_strassen = strassen(n, matrizA, matrizB);

    clock_t end = clock();
    time_spent += (double)(end-begin)/CLOCKS_PER_SEC;

    printf("O tempo gasto para na multiplicacao de strassen foi de %f segundos!\n", time_spent);
    
    time_spent = 0.0;
    begin = clock();

    resul_tradicional = tradicional(n, matrizA, matrizB);
    
    end = clock();
    time_spent += (double)(end-begin)/CLOCKS_PER_SEC;

    printf("O tempo gasto para na multiplicacao tradicional foi de %f segundos!\n", time_spent);

    int iguais = 1;

    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            if (resul_tradicional[i][j] != resul_strassen[i][j]) iguais = 0;
        }
    }

    free_matrix(resul_tradicional, n);
    free_matrix(resul_strassen, n);
    return iguais;
}
