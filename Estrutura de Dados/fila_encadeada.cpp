#include <bits/stdc++.h>

using namespace std;

typedef struct _node{
    int key;
    struct _node * next;
} node;

void append(node* &ptbegin, node* &ptend, const int value){
    node* element;

    element = (node*) malloc(sizeof(node));
    if (element == NULL){
        cout << "Memory Error: Not enough space in memory!";
        exit(0);
    }

    element->key = value;
    element->next = NULL;

    if (ptend == NULL){ 
        ptbegin = ptend = element;
    } else {
        ptend->next = element;
        ptend = element;
    }
}

int remove(node* &ptbegin, node* &ptend){
    if (ptbegin == NULL){
        cout << "The queue is empty!" << endl;
        return 0;
    }
    int value = ptbegin->key;
    if (ptbegin == ptend){
        free(ptbegin);
        ptbegin = ptend = NULL;
    } else {
        node* pt = ptbegin;
        ptbegin = ptbegin->next;
        free(pt);
    }
    return value;
}
int main(void){
    node *ptbegin, *ptend, *pt;
    ptbegin = ptend = NULL;

    append(ptbegin, ptend, 4);
    append(ptbegin, ptend, 21);
    append(ptbegin, ptend, 43);
    append(ptbegin, ptend, 5);  
    
    pt = ptbegin;
    while (pt != ptend){
        cout << pt->key << " ";
        pt = pt->next;
    }
    cout << pt->key << endl;

    cout << remove(ptbegin, ptend) << endl;
    cout << remove(ptbegin, ptend) << endl;
    cout << remove(ptbegin, ptend) << endl;
    cout << remove(ptbegin, ptend) << endl;
    cout << remove(ptbegin, ptend) << endl;

    /*
    pt = ptbegin;
    while (pt != ptend){
        cout << pt->key << " ";
        pt = pt->next;
    }
    cout << pt->key << endl;
    */
    cout << "a" << endl;
    return 0;
}