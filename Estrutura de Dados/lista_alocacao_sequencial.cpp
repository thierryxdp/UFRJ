#include <bits/stdc++.h>

using namespace std;

int TAM_VECTOR;

struct int_vector {
    int numElements = 0;
    int* vector;
};

void ini_vector_int(const int n, int_vector &array);
void append(const int value, int_vector &array);
void overflow(const int size, int_vector &array);
int busca(const int value, int_vector array);
void remove(const int value, int_vector array);

int main(void){

    int_vector vetor;
    TAM_VECTOR = 5;
    ini_vector_int(TAM_VECTOR, vetor);

    append(2, vetor);
    append(3, vetor);
    append(31, vetor);
    append(45, vetor);
    append(9, vetor);
    append(14, vetor);
    append(15, vetor);
    append(16, vetor);
    append(27, vetor);

    int a = busca(9, vetor);
    cout << a << endl;


    
    cout << "[";
    for (int i = 0; i < vetor.numElements - 1; i++) {
        cout << vetor.vector[i] << ", ";
    }
    cout << vetor.vector[vetor.numElements - 1] << "]" << endl;

    remove(9, vetor);
    remove(99, vetor);
    remove(3, vetor);

    cout << "[";
    for (int i = 0; i < vetor.numElements - 1; i++) {
        cout << vetor.vector[i] << ", ";
    }
    cout << vetor.vector[vetor.numElements - 1] << "]" << endl;
    return 0;
}

void ini_vector_int(const int size, int_vector &array){
    array.vector = (int*) malloc(size*sizeof(int));
    if (array.vector == NULL){
        cout <<  "Error: Not enough space in disk" << endl;
        exit(0);
    }
}

void append(const int value, int_vector &array){
    if (array.numElements < TAM_VECTOR){
        array.vector[array.numElements++] = value;
    } else {
        overflow(TAM_VECTOR, array);
        array.vector[array.numElements++] = value;
    }
    
}

void overflow(const int size, int_vector &array){
    int* temp = (int*) malloc(2*size*sizeof(int));
    TAM_VECTOR = TAM_VECTOR * 2;
    if (temp == NULL){
        cout <<  "Error: Not enough space in disk" << endl;
        exit(0);
    } else {
        for (int i = 0; i < size; i++){
            temp[i] = array.vector[i];
        }
        free(array.vector);
        array.vector = temp;
    }
}

int busca(const int value, int_vector array){
    int i = 0;
    while (i < array.numElements && array.vector[i] != value) i++;
    
    return i;
}

void remove(const int value, int_vector array){
    int position = busca(value, array);

    if(position != array.numElements){
        array.vector[position] = array.vector[array.numElements - 1];
        array.numElements--;
    } else {
        cout << "Tried to remove " << value << " but element ins't in the list!" << endl;
    }
}
