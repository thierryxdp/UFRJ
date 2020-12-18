#include <bits/stdc++.h>

using namespace std;

#define MAX_SIZE_VECTOR 10

int size;

void initialize(int* &queue, int &begin, int &end);
void append(const int value, int* &queue, int &begin, int &end);
int remove_begin(int* &queue, int &begin, int &end);

int main(void){
    int* queue;
    int begin, end;

    initialize(queue, begin, end);

    int res;

    append(2, queue, begin, end);
    append(5, queue, begin, end);
    append(4, queue, begin, end);
    append(2, queue, begin, end);
    append(5, queue, begin, end);
    append(4, queue, begin, end);
    append(2, queue, begin, end);
    append(5, queue, begin, end);
    append(4, queue, begin, end);
    append(4, queue, begin, end);
    append(4, queue, begin, end);

    if (begin != end){
        for (int i = begin; i != end; i = (i + 1) % size){
            cout << queue[i] << " ";
        }
        putchar('\n');
    } else {
        for (int i = begin; i < size; i++){
            cout << queue[i] << " ";
        }
        putchar('\n');
    }

    res = remove_begin(queue, begin, end);
    res = remove_begin(queue, begin, end);
    res = remove_begin(queue, begin, end);
    res = remove_begin(queue, begin, end);
    res = remove_begin(queue, begin, end);

    if (begin != end){
        for (int i = begin; i != end; i = (i + 1) % size){
            cout << queue[i] << " ";
        }
        putchar('\n');
    } else {
        for (int i = begin; i < size; i++){
            cout << queue[i] << " ";
        }
        putchar('\n');
    }
    

    return 0;
}

void initialize(int* &queue, int &begin, int &end){
    size = MAX_SIZE_VECTOR;
    queue = (int *) malloc(size*sizeof(int));
    if (queue == NULL){
        cout <<  "Memory error: didn't had enough space in memory!";
        exit(0);
    }
    begin = end = -1;
}

void append(const int value, int* &queue, int &begin, int &end){
    if (begin == -1){
        queue[0] = value;
        begin = 0;
        end = 1;
    } else {
        if (begin == end){
            cout << "Queue full: Overflow!" << endl;
            return;
        } else {
            queue[end] = value;
            end = (end + 1) % size;
        }
    }
}

int remove_begin(int* &queue, int &begin, int &end){
    int value;
    if (begin == -1){
        cout << "Empty queue: Underflow!" << endl;
        return -1;
    } else {
        value = queue[begin];
        begin = (begin + 1) % size;
        if (begin == end){
            begin = end = -1;
        }

    }
    return value;
}