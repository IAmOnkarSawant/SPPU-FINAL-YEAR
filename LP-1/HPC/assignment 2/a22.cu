#include<iostream>

using namespace std;


__global__ void multiply(int *ad,int *bd,int *cd,int n)
{

	int row=blockIdx.x;
	
	int sum=0;

	for(int i=0;i<n;i++)
	{


	sum=sum+ad[row*n+i]*bd[i];


	}

	cd[row]=sum;


}


int main()
{


	cout<<"Enter the size"<<endl;

	int n;
	cin>>n;

	int a[n][n],b[n], c[n];

	int size1=n*n*sizeof(int);
	int size2=n*sizeof(int);


	cudaEvent_t start,end;

	cudaEventCreate(&start);
	cudaEventCreate(&end);


	cout<<"The intial matrices are"<<endl;


		for(int i=0;i<n;i++)
		{

			for(int j=0;j<n;j++)
			{

				a[i][j]=3+i;
				cout<<a[i][j]<<" ";
			}
			b[i]=2+i;
			cout << b[i];
			cout<<endl;
		}


	int *ad, *bd, *cd;

	cudaMalloc(&ad,size1);
	cudaMemcpy(ad,a,size1,cudaMemcpyHostToDevice);


	cudaMalloc(&bd,size2);
	cudaMemcpy(bd,b,size2,cudaMemcpyHostToDevice);

	cudaMalloc(&cd,size2);





	dim3 grid(n,1);
	dim3 block(1,1);


	cudaEventRecord(start);



	multiply<<<grid,block>>>(ad,bd,cd,n);


	cudaEventRecord(end);

	cudaEventSynchronize(end);


	float time=0;
	
	cudaEventElapsedTime(&time,start,end);


	cout<<"The time is "<<time<<endl;




	cout<<"The multiplication is"<<endl;

	cudaMemcpy(c,cd,size2,cudaMemcpyDeviceToHost);

	for(int i=0;i<n;i++)
	{

		cout<<c[i]<<" ";
	}



}
