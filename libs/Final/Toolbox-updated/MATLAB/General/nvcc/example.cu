__global__ void addToVector(float * pi, float c)  {
       // Location in a 2D matrix
       int idx = threadIdx.x+blockIdx.x*blockDim.x;
       int idy = threadIdx.y+blockIdx.y*blockDim.y;
       // The Location in a 2D matrix, defined by a 1D value
       int id  = idx+idy*(blockDim.x*gridDim.x); 
       pi[id] += c;
}
