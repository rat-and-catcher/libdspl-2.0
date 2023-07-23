clear all; close all; clc;


N =  262144*16;

x = randn(N,1) + 1i * randn(N,1);


k = 4;
s = N;

for j = 1:21
  z = x(1:s);
  t = tic();
  for i = 1:k
    y = fft(z);
  endfor
  dt = toc(t) / k;
  mflops(22-j) = 5 * s * log2(s) / dt / 1E6 ;
  size(22-j) = s;
  fprintf("size = %8d   Mflops = %12.3f\n", s, mflops(22-j));
  k = k * 1.7;
  s = s / 2;
endfor

dspl_size = [2      
             4      
             8      
             16     
             32     
             64     
             128    
             256    
             512    
             1024   
             2048   
             4096   
             8192   
             16384  
             32768  
             65536  
             131072 
             262144 
             524288 
             1048576];
             

dspl_mflops = [597.7 
               1946.0
               4455.5
               5446.3
               4490.7
               4288.5
               3524.1
               5286.9
               3995.3
               3657.6
               2953.2
               2078.0
               2565.7
               2615.5
               2361.8
               2376.4
               2169.8
               2285.5
               2172.4
               1896.4];

python_size = [4194304
               2097152
               1048576
                524288
                262144
                131072
                 65536
                 32768
                 16384
                  8192
                  4096
                  2048
                  1024
                   512
                   256
                   128
                    64
                    32
                    16
                     8
                     4
                     2];
                     
                     
                     
                     
python_mflops = [2119.626
                 2147.070
                 2362.656
                 2351.777
                 2408.621
                 2678.743
                 3194.574
                 3978.322
                 5220.731
                 4671.613
                 4240.982
                 3585.080
                 3876.999
                 2556.301
                 2333.780
                 1301.660
                  606.947
                  294.469
                  127.103
                   37.574
                   15.669
                    4.110];                     
   
   plot(log2(size), mflops,log2(dspl_size), dspl_mflops, log2(python_size), python_mflops)