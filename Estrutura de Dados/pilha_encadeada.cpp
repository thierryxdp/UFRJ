#include <bits/stdc++.h>

using namespace std;

typedef struct _node{
    int key;
    struct _node *next;
} node;

void push(const int value, node* &pttop){
    node* element = (node*) malloc(sizeof(node));
    if (element == NULL){
        cout << "Memory Error: Not enough space in memory!";
        exit(0);
    }
    element->key = value;
    element->next = pttop;
    pttop = element;
}
int pop(node* &pttop){
    if (pttop == NULL){
        cout << "Underflow! Couldn't remove because the stack is empty! ";
        return 0;
    }
    int value = pttop->key;
    node* pt = pttop;
    pttop = pt->next;
    free(pt);
    return value;
}
int main(void){
    node* pttop = NULL;
    
    push(1, pttop);
    push(2, pttop);
    push(3, pttop);
    
    node* stack = pttop;
    while (stack->next != NULL){
        cout << stack->key << " ";
        stack = stack->next;
    }
    cout << stack->key << endl;

    cout << pop(pttop) << endl;

    stack = pttop;
    while (stack->next != NULL){
        cout << stack->key << " ";
        stack = stack->next;
    }
    cout << stack->key << endl;

    cout << pop(pttop) << endl;

    stack = pttop;
    while (stack->next != NULL){
        cout << stack->key << " ";
        stack = stack->next;
    }
    cout << stack->key << endl;

    cout << pop(pttop) << endl;
    cout << pop(pttop) << endl;

    return 0;
}