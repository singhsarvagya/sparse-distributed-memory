# sparse-distributed-memory
## This project is a simulator for Sparse Distributed Memory as discribed in the [paper](https://books.google.com/books?hl=en&lr=&id=I9tCr21-s-AC&oi=fnd&pg=PR11&dq=sparse+distributed+memory&ots=QTBN0SvwFJ&sig=6f0sDmXWn2WXFuHdP4EzGtbPTD4#v=onepage&q=sparse%20distributed%20memory&f=false) by P. Kanerva. 
## Following is the description of useful functions in the SDM simluator

### sdm(L, N, M, hammingRadius, bucketSize)
#### L is the number of hard-locations in the SDM
#### N is the number of bits in the location address
#### M is the number of bits in the memory vector 
#### hammingRadius is defined for read and write operations that access hard-address based on hamming distance between hard-addresses and provided address
#### bucket-size defines the higher and lower threshold of single memory buckets

### write(obj, vector, vector_address)
#### this function is used to write the value 'vector' at location-addresses that is within hammingRadius of provided vector_address

### write-associative(obj, vector)
#### this fucntion is used to write 'vector' into at location-addresses that is within hammingRadius of vector. For using this function, the dimension of location addresses and memory-vectors should be equal. 
