#include <bits/stdc++.h>

using namespace std;

#define MAX 10

int size;

void initialize_stack(int* &stack, int &top){
    size = MAX;
    stack = (int *) malloc(size * sizeof(int));
    top = 0;
}

void push(const int value, int* &stack, int &top){
    if (top < size){
        stack[top] = value;
        top++;
    } else {
        cout << "Not enough space in the stack, couldn't push element!" << endl;
        return;
    }  
}

int pop(int* stack, int& top){
    if (top == 0){
        cout << "Underflow! Cannot remove because the stack is empty!" << endl;
        return 0;
    }

    top--;
    return stack[top];
}

int main(void){
    int* stack;
    int top;
    initialize_stack(stack, top);

    push(1, stack, top);
    push(2, stack, top);
    push(3, stack, top);
    push(4, stack, top);

    for (int i = 0; i < top; i++){
        cout << stack[i] << " ";
    }
    putchar('\n');

    pop(stack, top);
    pop(stack, top);
    pop(stack, top);

    for (int i = 0; i < top; i++){
        cout << stack[i] << " ";
    }
    putchar('\n');

    return 0;
}