#include <stdio.h>
#include <dlfcn.h>
#include <string.h>
typedef int (*fptr)(int,int);
int main(){
    char op[7];
    int num1,num2;
    while(1){
        if(scanf("%5s %d %d",op,&num1,&num2)!=3)
            break;

        char libname[16]="./lib";
        strcat(libname,op);
        strcat(libname,".so");
        void* handle=dlopen(libname,RTLD_LAZY);
        if(handle==NULL){
            continue;
        }
        fptr func=dlsym(handle,op);
        if(func==NULL){
            dlclose(handle);
            continue;
        }
        printf("%d\n",func(num1,num2));
        dlclose(handle);
    }
}






