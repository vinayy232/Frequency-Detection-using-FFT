
# Frequency-Detection-using-FFT

If input Frequency is 2 Hz and its sampled over 8 Hz, then each cycle we will get 4 samples {0,1,0,-1} repeated for 8 times in 32-point input. 
FFT output for this signal will be all zero except at N =4 and 24. I.e X(4) = 16j 
X(24) = -16j  
Mod[X(4)] = Mod[X(24)] = 16 
Bin representation of FFT :  
Frequency represented by a bin will be in multiple of  fs/( N)


If Sampling frequency (fs) is 8 Hz and N = 32 then Frequency represented by a bin will be in multiple of 0.25 Hz. 
N = 0 will represent 0Hz, N= 1 will represent 0.25 Hz and so on. 
Using this concept if we are getting Higher Magnitude at any bin , it means the respective frequency represented by that BIN is present in the input. So if we get a magnitude of FFT 
output , with that we can say what frequency will be present at the input and for a complex number Magnitude can be computed using below formula: 
                           MOD(Z) = Sqrt ( Sqr (X) + SQR(Y))                                    
But this will further increase the complexity, so to reduce it, Easier way is also possible in which instead of taking Square and then square root we will take mod of real and imaginary part separately and by adding it and checking it with predefined higher value threshold can give the same result. 
After several testing with different frequency signal value 10 is taken as a threshold considering input value will be less than 3.3v real world signal. 

10 is represented as 20480 , to compare with this bigger value, mod output is multiplied with 0.01 (2 in Q21.11 ) and compared with 20

<img width="817" height="498" alt="image" src="https://github.com/user-attachments/assets/45cf3dc0-5fb7-46af-89fa-de2e25f10ec2" />

