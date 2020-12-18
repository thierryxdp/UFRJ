#include <bits/stdc++.h>

using namespace std;

typedef struct _node{
    int key;
    struct _node *next;
} node;

void init_list(node* &head){
    head = (node*)malloc(sizeof(node));
    if (head == NULL){
        cout << "Memory error: Couldn't allocate memory!" << endl;
        exit(0);
    }
    head->next = head;
}

node* search(node* head, const int value){
    node* pt = head;
    while (pt->next != head && pt->next->key < value){
        pt = pt->next;
    }
    return pt;
}

void append_list(node* head, const int value){
    node *element = (node*)malloc(sizeof(node));
    if (element == NULL){
        cout << "Memory error: Couldn't allocate memory!" << endl;
        exit(0);
    }

    element->key = value;

    node* pt = search(head, value);
    element->next = pt->next;
    pt->next = element;
    
}

int remove(node* &head, const int value){
    node* prev = search(head, value);
    if (prev->next->key != value){
        cout << "Error: element " << value << " isn't in the list so it couldn't be removed! ";
        return 0;
    } else {
        node* pt = prev->next;
        prev->next = pt->next;
        free(pt);
        return value;
    }
}
int main(void){
    node *head;
    init_list(head);

    append_list(head, 4);
    append_list(head, 5);
    append_list(head, 32);
    append_list(head, 0);
    append_list(head, 101);

    node* pt = head->next;
    cout << "List: ";
    while (pt != head){
        cout << pt->key << " ";
        pt = pt->next;
    }
    putchar('\n');

    cout << "Removed: " << remove(head, 5) << endl;

    pt = head->next;
    cout << "List: ";
    while (pt != head){
        cout << pt->key << " ";
        pt = pt->next;
    }
    putchar('\n');

    cout << "Removed: " << remove(head, 7) << endl;

    pt = head->next;
    cout << "List: ";
    while (pt != head){
        cout << pt->key << " ";
        pt = pt->next;
    }
    putchar('\n');
    
    cout << "Removed: " << remove(head, 101) << endl;
    cout << "Removed: " << remove(head, 4) << endl;
    cout << "Removed: " << remove(head, 32) << endl;

    pt = head->next;
    cout << "List: ";
    while (pt != head){
        cout << pt->key << " ";
        pt = pt->next;
    }
    putchar('\n');

    return 0;
}