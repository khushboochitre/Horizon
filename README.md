The following should be installed before building Horizon:

cmake: sudo apt-get install cmake

ninja: sudo apt install ninja-build

libffi: sudo apt-get install -y libffi-dev

Building Horizon

1) Download LLVM's source folder (llvm) included in this repository.

2) Clone clang's source folder to the tools directory present in the llvm folder using the following command:

   git clone https://github.com/llvm-mirror/clang
   
3) Clone source folder of compiler-rt to the projects directory present in the llvm folder using the following command:

   git clone https://github.com/llvm-mirror/compiler-rt

4) Create a new folder to build llvm (e.g. build).

5) Place the build.sh file present in the scripts folder to llvm’s build folder.

6) Specify the path to llvm’s source folder (downloaded in step 1) in the build.sh file.

7) Go to the build folder and execute the following commands to build llvm:

   ./build.sh

   ninja


Function files

1) Create a folder named logs in the $HOME directory.

2) Place all the files present in the folder FunctionFiles to $HOME/logs.

3) To disable the annotations for a specific function, add 1 in front of that function in the function file for corresponding benchmark.

For example, next_nonempty_voxel 1 


Polybench benchmarks

1) Download the source code for Polybench benchmarks from the following link:

https://sourceforge.net/projects/polybench/

2) Place the run.sh file present in scripts/Polybench folder to the source folder of Polybench (downloaded in the previous step).

3) Set the value of the variable POLYBENCH in the run.sh file to the path of Polybench’s source.

4) Set the value of the variable LLVM_ROOT_PATH in the run.sh file to the path of llvm’s build folder.

5) Set the variable BENCHMARK to the benchmark name in the run.sh file to execute the specific benchmarks. For example, BENCHMARK="jacobi-1d". The default value will execute all the benchmarks of polybench benchmark suite.

6) To execute the native run,

./run.sh native

7) To execute the annotation inference phase,

./run.sh get-annotation

8) To execute the annotation incorporation phase,

./run.sh use-annotation

9) To map the annotations to source code,

./run.sh map-annotation

10) To compile the benchmark with the most effective combination of optimizations enabled, set the variable GETPHASE_FLAGS to disable specific set of optimizations (-mllvm -disable-dse -mllvm -disable-gvn -mllvm -disable-licm -fno-vectorize -fno-slp-vectorize). Set the variable VECT_FLAG to execute the SLP vectorization pass (-disable-get-dynaa -slp-vectorizer) or Loop vectorization pass (-disable-get-dynaa -loop-vectorize), in case these optimizations are not a part of the most effective combination of optimizations set. For example, if the set of most effective combination of optimizations = {GVN, LV} then,

GETPHASE_FLAGS="-O3 -mllvm -loop-vect-enabled -mllvm -disable-dse -mllvm -disable-licm -fno-slp-vectorize"

VECT_FLAG="-disable-get-dynaa -slp-vectorizer"

Execute the following command to compile and run the benchmark,

./run.sh use-annotation

11) To get the precision of the benchmark, set the variable PREC_FLAG to "-O3 -aa-eval" in the run.sh file. Execute the native and use-annotation phases to get the obtained precision in both the phases.


SPLASH-2 benchmarks

1) Download SPLASH-2 benchmarks by following the link:

https://docs.google.com/document/d/1B7nZSqMLwkwoVNEj_58tMPTk4bKWvoEMbokOAjqeC-k/preview

Follow the "Get SPLASH-2" and "Patch SPLASH-2" sections from the document. 

2) Replace Makefile.config with the one present in the scripts/SPLASH-2 folder. 

3) Replace Makefile (apps/radiosity) with the one present in the scripts/SPLASH-2 folder. 

4) Set the value of the variable LLVM_ROOT_PATH in the Makefile.config file to the path of llvm’s build folder.

5) Set the value of the variable BASEDIR in the Makefile.config file to the path of SPLASH-2’s source directory.

6) Place the splashrun.sh file present in scripts/SPLASH-2 folder into the source folder of SPLASH-2 (where Makefile.config is present).

7) Set the variable BENCHMARK to the benchmark name in the splashrun.sh file to execute the specific benchmarks.

8) Set the variable THREADS to the required number of threads in the splashrun.sh file. Set the variable PREVTHREADS to the previous number of threads in the splashrun.sh file. For example,

If THREADS = 1, then PREVTHREADS =

If THREADS = 2, then PREVTHREADS = 1

If THREADS = 4, then PREVTHREADS = 2

If THREADS = 8, then PREVTHREADS = 4

If THREADS = 12, then PREVTHREADS = 12

Note: For the benchmarks barnes and water-nsquared, the number of threads needs to be set using the input files provided in the corresponding folders. The benchmarks fft, ocean and radix runs with the number of threads of power 2.

9) To execute the native run,

./splashrun.sh native

10) To execute the annotation inference phase,

./splashrun.sh get-annotation

11) To execute the annotation incorporation phase,

./splashrun.sh use-annotation

12) To map the annotations to source code,

./splashrun.sh map-annotation

13) To compile the benchmark with the most effective combination of optimizations enabled, set the variable GETPHASE_FLAGS to disable specific set of optimizations (-mllvm -disable-dse -mllvm -disable-gvn -mllvm -disable-licm -fno-vectorize -fno-slp-vectorize) in the Makefile. Set the variable VECT_FLAG in the Makefile to execute the SLP vectorization pass (-disable-get-dynaa -slp-vectorizer) or Loop vectorization pass (-disable-get-dynaa -loop-vectorize), in case these optimizations are not a part of the most effective combination of optimizations set. For example, if the set of most effective combination of optimizations = {GVN, LV} then,

GETPHASE_FLAGS="-O3 -mllvm -loop-vect-enabled -mllvm -disable-dse -mllvm -disable-licm -fno-slp-vectorize"

VECT_FLAG="-disable-get-dynaa -slp-vectorizer"

Execute the following command to compile and run the benchmark,

./splashrun.sh use-annotation

10) To get the precision of the benchmark, set the variable PREC_FLAG to "-O3 -aa-eval" in the Makefile.config file. Execute the native and use-annotation phases to get the obtained precision in both the phases.


CPU SPEC 2017 benchmarks

1) Place all the config (.cfg extension) files present in scripts/SPEC into the config folder of SPEC.

2) Replace Makefile.defaults present in benchspec with the Makefile.defaults present in scripts/SPEC.

3) Place the specrun.sh file present in scripts/SPEC into the base folder of SPEC.

4) Set the variable BENCHMARK to execute the specific benchmarks.

5) To execute the native run,

./specrun.sh native

6) To execute the annotation inference phase,

./specrun.sh get-annotation

7) To execute the annotation incorporation phase,

./specrun.sh use-annotation

8) To map the annotations to source code,

./specrun.sh map-annotation

9) To compile the benchmark with the most effective combination of optimizations enabled, set the variable GETPHASE_FLAGS to disable specific set of optimizations (-mllvm -disable-dse -mllvm -disable-gvn -mllvm -disable-licm -fno-vectorize -fno-slp-vectorize) in the Makefile.defaults. Set the variable VECT_FLAG in the Makefile.defaults to execute the SLP vectorization pass (-disable-get-dynaa -slp-vectorizer) or Loop vectorization pass (-disable-get-dynaa -loop-vectorize), in case these optimizations are not a part of the most effective combination of optimizations set. For example, if the set of most effective combination of optimizations = {GVN, LV} then,

GETPHASE_FLAGS="-O3 -mllvm -loop-vect-enabled -mllvm -disable-dse -mllvm -disable-licm -fno-slp-vectorize"

VECT_FLAG="-disable-get-dynaa -slp-vectorizer"

Execute the following command to compile and run the benchmark,

./specrun.sh use-annotation

10) To get the precision of the benchmark, set the variable PREC_FLAG to "-O3 -aa-eval" in the Makefile.defaults file. Execute the native and use-annotation phases to get the obtained precision in both the phases.


Note: While executing a script, if you get the "Permission denied" error, execute the following command before and then execute the script:

chmod +x script-name
