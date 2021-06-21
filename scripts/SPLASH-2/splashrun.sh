#!/bin/bash
SPLASH_ROOT_PATH=path_to_splash2_source
LOG_DIR=$HOME"/logs"
THREADS="2"
PREVTHREAD="1"
BENCHMARK="barnes radiosity raytrace water-nsquared fft lu radix ocean" 

if [ $# -eq 0 ]
  then
    echo "Please specify an option (native/get-annotation/use-annotation)"
    exit 0
fi

for val in $BENCHMARK
do
        if [ $val == "barnes" ];
        then
                name="barnes"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name"_"$PREVTHREAD".txt" $LOG_DIR/$name".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name"_"$THREADS".txt" $LOG_DIR/$name".txt"
                fi
                cd $SPLASH_ROOT_PATH/apps/$val/ && make clean
                cd $SPLASH_ROOT_PATH/apps/$val/ && make input=$1 filename=$name
                echo "Executing barnes"
                cd $SPLASH_ROOT_PATH/apps/$val/ && time -p ./BARNES < $SPLASH_ROOT_PATH/apps/$val/input > $SPLASH_ROOT_PATH/apps/$val/$val"."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name".txt" $LOG_DIR/$name"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -6 $val".native.txt") <(head -6 $val"."$1".txt")
                fi
        elif [ $val == "raytrace" ];
        then
                name="raytrace"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name"_"$PREVTHREAD".txt" $LOG_DIR/$name".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name"_"$THREADS".txt" $LOG_DIR/$name".txt"
                fi
                cd $SPLASH_ROOT_PATH/apps/$val/ && make clean
                cd $SPLASH_ROOT_PATH/apps/$val/ && make input=$1 filename=$name
                echo "Executing raytrace"
                cd $SPLASH_ROOT_PATH/apps/$val/ && time -p ./RAYTRACE -p $THREADS -a 32768 $SPLASH_ROOT_PATH/apps/$val/inputs/car.env/data > $SPLASH_ROOT_PATH/apps/$val/$val"."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name".txt" $LOG_DIR/$name"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -21 $val".native.txt") <(head -21 $val"."$1".txt")
                fi
        elif [ $val == "ocean" ];
        then
                name1="ocean_contiguous_partitions"
                name2="ocean_non_contiguous_partitions"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name1".txt"
                    rm -r $LOG_DIR/$name2".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name1"_"$PREVTHREAD".txt" $LOG_DIR/$name1".txt"
                        cp $LOG_DIR/$name2"_"$PREVTHREAD".txt" $LOG_DIR/$name2".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name1"_"$THREADS".txt" $LOG_DIR/$name1".txt"
                    cp $LOG_DIR/$name2"_"$THREADS".txt" $LOG_DIR/$name2".txt"
                fi
                cd $SPLASH_ROOT_PATH/apps/$val/contiguous_partitions/ && make clean
                cd $SPLASH_ROOT_PATH/apps/$val/contiguous_partitions/ && make input=$1 filename=$name1
                echo "Executing ocean_contiguous_partitions"
                cd $SPLASH_ROOT_PATH/apps/$val/contiguous_partitions/ && time -p ./OCEAN -p $THREADS -n 4098 -t 14400 -r 10000 > $SPLASH_ROOT_PATH/apps/$val/contiguous_partitions/$val"_contiguous_partitions."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name1".txt" $LOG_DIR/$name1"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -8 $val"_contiguous_partitions.native.txt") <(head -8 $val"_contiguous_partitions."$1".txt")
                fi
                cd $SPLASH_ROOT_PATH/apps/$val/non_contiguous_partitions/ && make clean
                cd $SPLASH_ROOT_PATH/apps/$val/non_contiguous_partitions/ && make input=$1 filename=$name2
                echo "Executing ocean_non_contiguous_partitions"
                cd $SPLASH_ROOT_PATH/apps/$val/non_contiguous_partitions/ && time -p ./OCEAN -n 4098 -p $THREADS -e 1e-07 -r 20000 -t 28800 > $SPLASH_ROOT_PATH/apps/$val/non_contiguous_partitions/$val"_non_contiguous_partitions."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name2".txt" $LOG_DIR/$name2"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -8 $val"_non_contiguous_partitions.native.txt") <(head -8 $val"_non_contiguous_partitions."$1".txt")
                fi
        elif [ $val == "radiosity" ];
        then
                name="radiosity"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name"_"$PREVTHREAD".txt" $LOG_DIR/$name".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name"_"$THREADS".txt" $LOG_DIR/$name".txt"
                fi
                cd $SPLASH_ROOT_PATH/apps/$val/ && make clean
                cd $SPLASH_ROOT_PATH/apps/$val/ && make input=$1 filename=$name
                echo "Executing radiosity"
                cd $SPLASH_ROOT_PATH/apps/$val/ && time -p ./RADIOSITY -p $THREADS -batch -largeroom -bf 0.00025 > $SPLASH_ROOT_PATH/apps/$val/$val"."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name".txt" $LOG_DIR/$name"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(tail -n 119 $val".native.txt") <(tail -n 119 $val"."$1".txt")
                fi
        elif [ $val == "water-nsquared" ];
        then
                name="water-nsquared"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name"_"$PREVTHREAD".txt" $LOG_DIR/$name".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name"_"$THREADS".txt" $LOG_DIR/$name".txt"
                fi
                cd $SPLASH_ROOT_PATH/apps/$val/ && make clean
                cd $SPLASH_ROOT_PATH/apps/$val/ && make input=$1 filename=$name
                echo "Executing water-nsquared"
                cd $SPLASH_ROOT_PATH/apps/$val/ && time -p ./WATER-NSQUARED < $SPLASH_ROOT_PATH/apps/$val/input > $SPLASH_ROOT_PATH/apps/$val/$val"."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name".txt" $LOG_DIR/$name"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -32 $val".native.txt") <(head -32 $val"."$1".txt")
                fi
        elif [ $val == "fft" ];
        then
                name="fft"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name"_"$PREVTHREAD".txt" $LOG_DIR/$name".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name"_"$THREADS".txt" $LOG_DIR/$name".txt"
                fi
                cd $SPLASH_ROOT_PATH/kernels/$val/ && make clean
                cd $SPLASH_ROOT_PATH/kernels/$val/ && make input=$1 filename=$name
                echo "Executing fft"
                cd $SPLASH_ROOT_PATH/kernels/$val/ && time -p ./FFT -m 28 -p $THREADS > $SPLASH_ROOT_PATH/kernels/$val/$val"."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name".txt" $LOG_DIR/$name"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -8 $val".native.txt") <(head -8 $val"."$1".txt")
                fi
        elif [ $val == "lu" ];
        then
                name1="lu_contiguous_blocks"
                name2="lu_non_contiguous_blocks"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name1".txt"
                    rm -r $LOG_DIR/$name2".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name1"_"$PREVTHREAD".txt" $LOG_DIR/$name1".txt"
                        cp $LOG_DIR/$name2"_"$PREVTHREAD".txt" $LOG_DIR/$name2".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name1"_"$THREADS".txt" $LOG_DIR/$name1".txt"
                    cp $LOG_DIR/$name2"_"$THREADS".txt" $LOG_DIR/$name2".txt"
                fi
                cd $SPLASH_ROOT_PATH/kernels/$val/contiguous_blocks/ && make clean
                cd $SPLASH_ROOT_PATH/kernels/$val/contiguous_blocks/ && make input=$1 filename=$name1
                echo "Executing lu_contiguous_blocks"
                cd $SPLASH_ROOT_PATH/kernels/$val/contiguous_blocks/ && time -p ./LU -n 8000 -b 32 -p $THREADS > $SPLASH_ROOT_PATH/kernels/$val/contiguous_blocks/$val"_contiguous_blocks."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name1".txt" $LOG_DIR/$name1"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -7 $val"_contiguous_blocks.native.txt") <(head -7 $val"_contiguous_blocks."$1".txt")
                fi
                cd $SPLASH_ROOT_PATH/kernels/$val/non_contiguous_blocks/ && make clean
                cd $SPLASH_ROOT_PATH/kernels/$val/non_contiguous_blocks/ && make input=$1 filename=$name2
                echo "Executing lu_non_contiguous_blocks"
                cd $SPLASH_ROOT_PATH/kernels/$val/non_contiguous_blocks/ && time -p ./LU -n 8000 -b 32 -p $THREADS > $SPLASH_ROOT_PATH/kernels/$val/non_contiguous_blocks/$val"_non_contiguous_blocks."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name2".txt" $LOG_DIR/$name2"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -7 $val"_non_contiguous_blocks.native.txt") <(head -7 $val"_non_contiguous_blocks."$1".txt")
                fi
        elif [ $val == "radix" ];
        then
                name="radix"
                if [ $1 == "get-annotation" ];
                then
                    rm -r $LOG_DIR/$name".txt"
                    if [ $THREADS != 1 ];
                    then
                        cp $LOG_DIR/$name"_"$PREVTHREAD".txt" $LOG_DIR/$name".txt"
                    fi
                fi
                if [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    cp $LOG_DIR/$name"_"$THREADS".txt" $LOG_DIR/$name".txt"
                fi
                cd $SPLASH_ROOT_PATH/kernels/$val/ && make clean
                cd $SPLASH_ROOT_PATH/kernels/$val/ && make input=$1 filename=$name
                echo "Executing radix"
                cd $SPLASH_ROOT_PATH/kernels/$val/ && time -p ./RADIX -p $THREADS -n 256000000 -r 4096 > $SPLASH_ROOT_PATH/kernels/$val/$val"."$1".txt"
                if [ $1 == "get-annotation" ];
                then
                    cp $LOG_DIR/$name".txt" $LOG_DIR/$name"_"$THREADS".txt"
                fi
                if [ $1 == "get-annotation" ] || [ $1 == "use-annotation" ] || [ $1 == "map-annotation" ];
                then
                    diff <(head -8 $val".native.txt") <(head -8 $val"."$1".txt")
                fi
        else
            echo "Please enter valid benchmark name."
        fi
done

