#import <stdio.h>

void btoi(char **ascii){
  int aux=0;
  for (int i =0; *ascii[i] !='\0';++i){
      aux=aux*10+*ascii[i]-'0';
  }
  **ascii=aux;
  printf("%d\n",**ascii);
}

int main(){
  char *a="1231";
  char **arr;
  arr[0]=a;
  btoi(arr[0]);
  return 0;
}
