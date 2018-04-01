#include<stdio.h>
int A[10005];

int main()
{
	int N,i,j,k;
	int sum=0;
	for(i=1;i<=N;i++)
	{
	A[i]=i;
	sum+=A[i];
	}
	
	return 0;
}
