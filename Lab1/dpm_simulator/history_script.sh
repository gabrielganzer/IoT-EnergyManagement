#!/bin/bash
echo "[sys] Initializing..."
mkdir -p results/history2
k1=-4.42185232119070e-05
k2=0.726771518733501
k3=27.9968345531671

echo "[init] Uniform distribution - High utilization"
	for i in {0..100..2}
	do
		for j in {0..100..2}
		do
				./dpm_simulator -h $k1 $k2 $k3 $i $j -psm example/psm.txt -wl ../workloads/wl_high.txt -res results/history2/case1.txt >> results/history2/case1_sim.txt
		done
	done
echo "[init] Uniform distribution - Low utilization"
	for i in {0..400..8}
	do
		for j in {0..400..8}
		do
			./dpm_simulator -h $k1 $k2 $k3 $i $j -psm example/psm.txt -wl ../workloads/wl_low.txt -res results/history2/case2.txt >> results/history2/case2_sim.txt
		done
	done
echo "[init] Normal distribution"
	for i in {0..200..4}
	do
		for j in {0..200..4}
		do
			./dpm_simulator -h $k1 $k2 $k3 $i $j -psm example/psm.txt -wl ../workloads/wl_normal.txt -res results/history2/case3.txt >> results/history2/case3_sim.txt
		done
	done
echo "[init] Exponential distribution"
	for i in {0..500..10}
	do
		for j in {0..500..10}
		do
			./dpm_simulator -h $k1 $k2 $k3 $i $j -psm example/psm.txt -wl ../workloads/wl_exp.txt -res results/history2/case4.txt >> results/history2/case4_sim.txt
		done
	done
echo "[init] Tri-modal distribution"
	for i in {0..200..4}
	do
		for j in {0..200..4}
		do
			./dpm_simulator -h $k1 $k2 $k3 $i $j -psm example/psm.txt -wl ../workloads/wl_tri.txt -res results/history2/case5.txt >> results/history2/case5_sim.txt
		done
	done
echo "[init] Custom workload 1"
	for i in {0..400..8}
	do
		for j in {0..400..8}
		do
			./dpm_simulator -h $k1 $k2 $k3 $i $j -psm example/psm.txt -wl ../workloads/custom_workload_1.txt -res results/history2/custom1.txt >> results/history2/custom1_sim.txt
		done
	done
echo "[init] Custom workload 2"
	for i in {0..400..8}
	do
		for j in {0..400..8}
		do
			./dpm_simulator -h $k1 $k2 $k3 $i $j -psm example/psm.txt -wl ../workloads/custom_workload_2.txt -res results/history2/custom2.txt >> results/history2/custom2_sim.txt
		done
	done

echo "\n[sys] OK!"
