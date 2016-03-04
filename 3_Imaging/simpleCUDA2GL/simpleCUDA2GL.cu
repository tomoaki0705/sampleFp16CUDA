/*
 * Copyright 1993-2014 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */

// Utilities and system includes

#include <helper_cuda.h>

// clamp x to range [a, b]
__device__ float clamp(float x, float a, float b)
{
    return max(a, min(b, x));
}

__device__ int clamp(int x, int a, int b)
{
    return max(a, min(b, x));
}

// convert floating point rgb color to 8-bit integer
__device__ int rgbToInt(float r, float g, float b)
{
    r = clamp(r, 0.0f, 255.0f);
    g = clamp(g, 0.0f, 255.0f);
    b = clamp(b, 0.0f, 255.0f);
    return (int(b)<<16) | (int(g)<<8) | int(r);
}

__global__ void
cudaProcess(unsigned int *g_odata, unsigned short *g_indata, int imgw)
{
    extern __shared__ uchar4 sdata[];

    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int bw = blockDim.x;
    int bh = blockDim.y;
    int x = blockIdx.x*bw + tx;
    int y = blockIdx.y*bh + ty;

	unsigned short a = g_indata[y*imgw+x];
	float b;
	b = __half2float(a);

    float4 f4 = make_float4((x & 0x20)?100:0,0,(y & 0x20)?100:0,0);
    uchar4 c4;
	c4.x = (unsigned char)(f4.x * b);
	c4.y = (unsigned char)(f4.y * b);
	c4.z = (unsigned char)(f4.z * b);
    g_odata[y*imgw+x] = rgbToInt(c4.z, c4.y, c4.x);
}

extern "C" void
launch_cudaProcess(dim3 grid, dim3 block, int sbytes,
                   unsigned short *g_indata,
                   unsigned int *g_odata,
                   int imgw)
{
    cudaProcess<<< grid, block, sbytes >>>(g_odata, g_indata, imgw);

}
