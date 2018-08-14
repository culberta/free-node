#!/bin/bash 

# print node name, num of cores and num of cpus allocated

counter=1
while [ $counter -le 761 ]
do
    if [ $counter -ge 100 ]
    then
	nodenum="node$counter"
    elif [ $counter -ge 10 ]
    then
	nodenum="node0$counter"
    else
	nodenum="node00$counter"
    fi

    var=$(scontrol -o show node $nodenum)
    if [[ $var == "Node $nodenum not found" ]]
    then
	((counter++))
    else
	node_info=($var)
	node_name=${node_info[0]}
    
	counter1=1
	until [[ ${node_info[$counter1]:0:6} == "CPUTot" ]]
	do
	    ((counter1++))
	done

	cpu_tot=${node_info[$counter1]}

	counter2=1
	until [[ ${node_info[$counter2]:0:8} == 'CPUAlloc' ]]
	do
	    ((counter2++))
	done
    
	cpu_alloc=${node_info[$counter2]}

	cpu_free="$((${cpu_tot:7} - ${cpu_alloc:9}))"

	echo ${node_name:9}':' $cpu_free 
	((counter++))
    fi
done
