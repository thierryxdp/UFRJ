#include <iostream>

using namespace std;

#define TAM 200

void up(int position, int *&heap){
    if (position != 0){
        int father = (position-1)/2;
        if (heap[father] > heap[position]){
            int temp = heap[position];
            heap[position] = heap[father];
            heap[father] = temp;
            up(father, heap); 
        }
    }
}

void down(int position, int *&heap, int numElem){
    int position_left_child = 2 * position + 1;
    int position_smaller_child;
    if (position_left_child < numElem){
        position_smaller_child = position_left_child;
        int position_right_child = position_left_child + 1;
        if (position_right_child < numElem){
            if (heap[position_right_child] < heap[position_left_child]) position_smaller_child = position_right_child;
        }
        if (heap[position] > heap[position_smaller_child]){
            int temp = heap[position];
            heap[position] = heap[position_smaller_child];
            heap[position_smaller_child] = temp;
            down(position_smaller_child, heap, numElem);
        }
    }
}

void overflow(){
    cout << "Error: not enough space defined!" << endl;
    exit (0);
}

void insert(int value, int *&heap, int &numElem){
    if (numElem == TAM){
        overflow();
    }

    heap[numElem] = value;
    up(numElem, heap);
    numElem++;
}

void remove(int value, int *&heap, int &numElem){

    if (numElem > 0){
        numElem--;
        heap[0] = heap[numElem];
        down(0, heap, numElem);
    }
}

int main(void){
    int *heap = (int *) malloc(TAM*sizeof(int));
    int numElem = 0;

    insert(10, heap, numElem);
    insert(2, heap, numElem);
    insert(5, heap, numElem);
    insert(3, heap, numElem);

    

    for (int i = 0; i < numElem; i++){
        cout << heap[i] << " ";
    }
    cout << endl;
    
    remove(2, heap, numElem);

    for (int i = 0; i < numElem; i++){
        cout << heap[i] << " ";
    }
    cout << endl;
        
    return 0;
}