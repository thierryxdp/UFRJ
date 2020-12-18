#include <bits/stdc++.h>

using namespace std;

typedef struct _node{
    int key;
    struct _node * next;
} node;

void initialize_node(node* &pt){
    pt = (node *) malloc(sizeof(node));
    if (pt == NULL){
        cout << "Memory Error: Not enough space in memory!";
        exit(0);
    }
    pt->next = NULL;
    pt->key = 0;
}

void append(const int value, node* &ptlist){
    node* element;
    initialize_node(element);

    element->key = value;

    element->next = ptlist;
    ptlist = element;
}


node* search(node* ptlist, const int value, node* &prev){
    node* pt = ptlist;
    prev = NULL;
    while(pt != NULL && pt->key != value){
        prev = pt;
        pt = pt->next;
    }
    return pt;
}

void remove(node* &ptlist, const int value, node* &prev){
    node* pt = search(ptlist, value, prev);

    if (pt == NULL){
        cout << "Couldn't remove because the element ins't in the list!" << endl;
    } else{
        if (prev != NULL){
            prev->next = pt->next;
        } else {
            ptlist = pt->next;
        }
        free(pt);
    }
}

int main(void){
    
    node* ptlist = NULL;
    node* prev;
    append(4, ptlist);
    append(27, ptlist);
    append(12, ptlist);  

    node* pt = ptlist;
    while(pt->next != NULL){
        cout << pt->key << " ";
        pt = pt->next;
    }
    cout << pt->key << endl;

    pt = search(ptlist, 13, prev);
    if (pt != NULL){
        cout << pt->key << endl;
    } else {
        cout << "Element ins't in the list!" << endl;
    }
    
    
    remove(ptlist, 12, prev);
    remove(ptlist, 4, prev);
    remove(ptlist, 42, prev);
    
    pt = ptlist;
    while(pt->next != NULL){
        cout << pt->key << " ";
        pt = pt->next;
    }
    cout << pt->key << endl;

    return 0;
}