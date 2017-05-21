classdef sdm 
   properties 
       L % number of hard locations in memory 
       N % bit-size of location addresses 
       M % bit-size of the vectors stored in SDM
       hammingRadius % used when searching reading soemthing from the memory
       bucketSize % size of the bit-buckets in memory
       addressLocations % hard location addresses in the memory 
       memory % memory to store vectors 
   end 
   
   methods
       % constructor to set the object attributes 
       function obj = sdm(L, N, M, hammingRadius, bucketSize)
            if log2(L) < N
               obj.L = L;
            else 
                error('Number of hard locations cannot be larger than the address space');
            end
            
            obj.N = N;
            obj.M = M;
            
            if hammingRadius <= M
                obj.hammingRadius = hammingRadius;
            else
                error('Hamming radius cannot be greater than the vector length');
            end
            
            obj.bucketSize = bucketSize;
            
            % generates random binary vectors of length N 
            % which are used as hard locations in the SDM
            obj.addressLocations = randi([0,1], L, N);
            
            % initializing the memory to zero 
            % to indicate that the memory is clean 
            obj.memory = zeros(L, M);
       end 
       
       % functiont to set value of L 
       function obj = set.L(obj, L)
           % L must be an integer 
           if isscalar(L) && rem(L,1) == 0  && L > 0
               obj.L = L ;
           else
               error('L must be a scalar positive integer.');
           end
       end
       
       % function to set value of N 
       function obj = set.N(obj, N)
           % L must be an integer 
           if isscalar(N) && rem(N,1) == 0 && N > 0
               obj.N = N ;
           else
               error('N must be a scalar positive integer.');
           end
       end
       
       % Function to set value of M 
       function obj = set.M(obj, M)
           % M must be an integer 
           if isscalar(M) && rem(M,1) == 0 && M > 0
               obj.M = M ;
           else
               error('M must be a scalar positive integer.');
           end
       end
       
       % function to set value of bucket size     
       function obj = set.bucketSize(obj, bucketSize)
           % L must be an integer 
           if isscalar(bucketSize) && rem(bucketSize,1) == 0 && bucketSize > 0
               obj.bucketSize = bucketSize ;
           else
               error('bucketSize must be a scalar positive integer.');
           end
       end   
       
       % function to implement associative memory where 
       % the vector both the address and the data
       function obj = write_associative(obj, vector)
           if obj.N ~= obj.M 
               error('For write associative, the bit-size initialized for vectors and location-address must be equal.');
           else
               obj = obj.write(vector, vector);
           end
       end 
       
       % function to store a vector in the memory 
       function obj = write(obj, vector, vector_address)
           if size(vector, 1) ~= 1 && size(vector, 2) ~= obj.M % dimension for the vector must be equal to initialized value 
               error('The dimension of the vector must be equal to the initlized bit-size for the vectors.');
           elseif size(vector_address, 1) ~= 1 && size(vector_address, 2) ~= obj.N % dimension of the vector address must be equal to the location address
               error('The dimension of the vector-address must be equal to the initilized bit-size of the location-addresses');
           elseif sum(sum (abs(vector>1))) > 0 % the vector must be binary matrix 
               error('Vectors with only binary values are allowed');
           elseif sum(sum (abs(vector_address>1))) > 0 % vector address must be binary 
               error('Vectors addresses with only binary values are allowed');
           else % given that all conditions are satisfies the vector must be comitted to memory 
               for i=1:obj.L
                  location = obj.addressLocations(i,:);
                  vector(vector == 0) = -1;
                  if pdist2(location, vector_address, 'hamming') <= (obj.hammingRadius/obj.N)
                      obj.memory(i,:) = obj.memory(i,:)+vector;
                  end    
               end
               obj.memory(obj.memory>obj.bucketSize) = obj.bucketSize;
               obj.memory(obj.memory<-obj.bucketSize) = -obj.bucketSize;
           end 
       end 
       
       %function to impelment associative memory read
       % where the data and the data address are the same
       function vector = read_associative(obj, vector, itr)
           if obj.N ~= obj.M 
               error('For read associative, the bit-size initialized for vectors and location-address must be equal.');
           else
               for i = 1:itr
                    vector = obj.read(vector);
               end
           end
       end
       
       % function to read a vector from the memory 
       function vector = read(obj, vector_address)
           if size(vector_address, 1) ~= 1 && size(vector_address, 2) ~= obj.N % dimension of the vector address must be equal to the location address
               error('The dimension of the vector-address must be equal to the initilized bit-size of the location-addresses');
           elseif  sum(sum (abs(vector_address>1))) > 0 % vector address must be binary 
               error('Vectors addresses with only binary values are allowed');
           else
               vector = zeros(1, obj.M);
               for i=1:obj.L
                   location = obj.addressLocations(i,:);
                   if pdist2(location, vector_address, 'hamming') <= (obj.hammingRadius/obj.N)
                       vector = vector + obj.memory(i,:);
                   end
               end
               vector(vector>0) = 1; 
               vector(vector<0) = -1;
               vector(vector==0) = (randi([0,1])-0.5)*2;
               vector(vector==-1) = 0;
           end
       end
       function obj = testing(obj)
           for i = 1:10
               vector = randi([0,1], 1, obj.N);
               obj = obj.write_associative(vector);
           end
       end
   end
end