#include<iostream>

using namespace std;

__global__ void add(int *a,int *b,int *c,int n)
{



 int id=blockIdx.x*blockDim.x+threadIdx.x;


if(id<n)
{

c[id]=b[id]+a[id];


}



}


int main()
{




cout<<"Enter the no of elements"<<endl;
int n;

cin>>n;
int a[n],b[n],c[n];

for(int i=0;i<n;i++)
{

a[i]=b[i]=i+1;

}

int *ad,*bd,*cd;

int size=n*sizeof(int);


cudaEvent_t start,end;


cudaEventCreate(&start);
cudaEventCreate(&end);







cudaMalloc(&ad,size);
cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);

cudaMalloc(&bd,size);
cudaMemcpy(bd,b,size,cudaMemcpyHostToDevice);


cudaMalloc(&cd,size);

dim3 grid(256,1);
dim3 block(32,1);


cudaEventRecord(start);



add<<<grid,block>>>(ad,bd,cd,n);


cudaEventRecord(end);
cudaEventSynchronize(end);


float time=0;

cudaEventElapsedTime(&time,start,end);







cudaMemcpy(c,cd,size,cudaMemcpyDeviceToHost);

for(int i=0;i<n;i++)
{

cout<<c[i]<<endl;


}


cout<<"The time required is"<<time<<endl;


}
