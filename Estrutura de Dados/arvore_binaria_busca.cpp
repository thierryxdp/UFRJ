#include <bits/stdc++.h>

using namespace std;
typedef struct _tno{
    struct _tno *left;
    int key;
    struct _tno *right;
} tno;

tno* busca(tno *ptraiz, int value){
    if (ptraiz == NULL)
        return ptraiz;
    if (ptraiz->key == value){
        return ptraiz;
    } else {
        if (value < ptraiz->key){
            return busca(ptraiz->left, value);
        } else {
            return busca(ptraiz->right, value);
        }
    }
}

void insere(tno *&ptraiz, int value){
    if (ptraiz == NULL){
        ptraiz = (tno*) malloc(sizeof(tno));
        if (ptraiz == NULL){
            cout << "Couldn't allocate memory" << endl;
            exit(0);
        }
        ptraiz->key = value;
        ptraiz->left = ptraiz->right = NULL;
    } else {
        if (value >= ptraiz->key){
            insere(ptraiz->right, value);
        } else {
            insere(ptraiz->left, value);
        }
    }
}

void preOrdem(tno *ptarv){
    if (ptarv != NULL){
        cout << ptarv->key << " ";
        preOrdem(ptarv->left);
        preOrdem(ptarv->right);
    }
}

void posOrdem(tno *ptarv){
    if (ptarv != NULL){
        posOrdem(ptarv->left);
        posOrdem(ptarv->right);
        cout << ptarv->key << " ";
    }
}

void remove(tno *&ptraiz, int value){
    tno *pai = NULL;
    tno *pt = ptraiz;

    while (pt != NULL && pt->key != value){
        pai = pt;
        if (value < pt->key){
            pt = pt->left;
        } else {
            pt = pt->right;
        }
    }

    if (pt == NULL){
        cout << "Couldn't find element " << value <<  " to be removed!" << endl;
    } else {
        // found value

        int quantidade_filhos = 0;
        tno *ptfilho = NULL;

        if (pt->left != NULL){
            ptfilho = pt->left;
            quantidade_filhos++;
        }
        if (pt->right != NULL){
            ptfilho = pt->right;
            quantidade_filhos++;
        }

        if (quantidade_filhos < 2){
            if (pai == NULL){
                ptraiz = ptfilho;
            } else {
                if (pai->left == pt){
                    pai->left = ptfilho;
                } else {
                    pai->right = ptfilho;
                }
            }
            free(pt);
        } else {
            tno *sucessor = pt->right;
            tno *ant_sucessor = pt;
            while (sucessor->left != NULL){
                ant_sucessor = sucessor;
                sucessor = sucessor->left;
            }

            pt->key = sucessor->key;

            if (ant_sucessor->left == sucessor){
                ant_sucessor->left = sucessor->left;
            } else {
                ant_sucessor->right = sucessor->right;
            }
            free(sucessor);
        }
    }
}
void emOrdem(tno *ptarv){
    if (ptarv != NULL){
        emOrdem(ptarv->left);
        cout << ptarv->key << " ";
        emOrdem(ptarv->right);
    }
}

int main(void){
    tno *ptraiz;
    ptraiz = NULL;
    
    insere(ptraiz, 10);
    insere(ptraiz, 5);
    insere(ptraiz, 25);
    insere(ptraiz, 12);
    insere(ptraiz, 3);
    insere(ptraiz, 33);

    cout << "Pre-ordem: ";
    preOrdem(ptraiz);
    cout << endl;

    cout << "Pos-ordem: ";
    posOrdem(ptraiz);
    cout << endl;

    cout << "Em-ordem: ";
    emOrdem(ptraiz);
    cout << endl;

    tno *pt = busca(ptraiz, 10);
    if (pt != NULL){
        cout << pt->key << endl;
    } else {
        cout << "Element not found!" << endl;
    }
    
    pt = busca(ptraiz, 2);
    if (pt != NULL){
        cout << pt->key << endl;
    } else {
        cout << "Element not found!" << endl;
    }

    remove(ptraiz, 10);
    remove(ptraiz, 33);
    remove(ptraiz, 2);

    cout << "Em-ordem: ";
    emOrdem(ptraiz);
    cout << endl;

    return 0;
}