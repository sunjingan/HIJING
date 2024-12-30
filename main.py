from mpi4py import MPI
import os
import shutil
from subprocess import call, run, PIPE
import h5py
from random import *
import glob 
import numpy as np

def randn( nseed=11358913111, low=1, high=2E8):
    '''return N random int numbers '''
    result = 0
    #seed(nseed)
    
    result=randint(low, high) 
    return result

def setup_and_run(rank):
    """Setup and run HIJING simulation for a given rank."""
    # Create directory for this rank
    rank_dir = f"Rank_{rank}"
    if not os.path.exists(rank_dir):
        os.mkdir(rank_dir)
    
    # Copy hijing-main into the rank directory
    hijing_main_src = "hijing-main"  # Path to the original hijing-main folder
    hijing_main_dst = os.path.join(rank_dir, "hijing-main")
    if not os.path.exists(hijing_main_dst):
        shutil.copytree(hijing_main_src, hijing_main_dst)
    
    # Navigate to hijing-main directory
    os.chdir(hijing_main_dst)

    #generate the random seed
    ran = randn()

    # Write the test.in file
    test_in_content = '''{}
CMS,5020
P,A
1,1,208,82
10000
0
0
    '''.format(ran)

    open('test.in', 'w').write(test_in_content)
    
    # Redirect output to log files
    make_log = open(f"{rank_dir}_make.log", "w")
    test_log = open(f"{rank_dir}_test.log", "w")

    # Run `make` and redirect output
    run("make", shell=True, stdout=make_log, stderr=make_log)
    
    # Execute the simulation and redirect output
    run("./test.exe < test.in", shell=True, stdout=test_log, stderr=test_log)

    # Close log files
    make_log.close()
    test_log.close()
    
    #After running, the final particles are in ./output path
    #We need to gather it 
    files = glob.glob("./output/final_*.dat")
    nfiles = len(files)
    with h5py.File("events_in_Rank{}.h5".format(rank),"w") as f:
        for ievent in range(nfiles):
            data = np.loadtxt("output/final_{}.dat".format(ievent))
            #data header is : px py pz E mass PID charged
            f.create_dataset("final_{}.dat".format(ievent),data=data)
    call("mv events_in_Rank{}.h5 ../../".format(rank), shell = True)
    # Return to the original directory
    os.chdir("../../")
    #call("rm -rf Rank_{}".format(rank),shell=True)

def main():
    """Main function to run the simulation using MPI."""
    # Initialize MPI
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    size = comm.Get_size()
    
    print(f"Process {rank}/{size} starting...")
    
    # Run the setup and simulation for this rank
    setup_and_run(rank)
    
    print(f"Process {rank} finished.")

if __name__ == "__main__":
    main()
