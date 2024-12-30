# This is package to run HIJING in multi-threads way

## How to run

We use "mpi4py" to lanuch the job. Please make sure your enivornmant support mpi4py.

mpirun -np 5 python main.py

it means using 5 cores to run simulations.


## What we get in each rank ?

In each rank, a diretory Rank_{rank} will be created. The HIJING is performed in each rank by ./test.exe < test.in 

The test.in is the input to the HIJING. It reads,

20000118      #random seed
CMS,5020      #CMS means center of mass frame. 5020 is energy in MeV
P,A           #means p-A collisions
1,1,208,82    #1,1 is proton. 208 82 is Pb
10000         #number of events
0             #print warning messages
0             #do't store decay particles

We will get the final particles data in output dir (final_0.dat, final_1.dat, ....). 
Note that the final_*.dat header is: px py pz E mass PID charged
And, we will collect it into a h5 file. Finally, we move this h5 file to the home dir.
