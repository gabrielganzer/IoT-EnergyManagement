#!/bin/bash
echo "[sys] Initializing..."
mkdir -p results/history
k1=-4.42185232119070e-05
k2=0.726771518733501
k3=27.9968345531671

echo "[init] Uniform distribution - High utilization"
	for j in {0..100..2}
			do
				./dpm_simulator -h $k1 $k2 $k3 40 $j -psm example/psm.txt -wl ../wl_gen/wl_high.txt -res results/history/case1.txt >> results/history/case1_sim.txt
			done
echo "[init] Uniform distribution - Low utilization"
	for j in {0..400..8}
		do
			./dpm_simulator -h $k1 $k2 $k3 80 $j -psm example/psm.txt -wl ../wl_gen/wl_low.txt -res results/history/case2.txt >> results/history/case2_sim.txt
		done
echo "[init] Normal distribution"
		for j in {0..200..4}
		do
			./dpm_simulator -h $k1 $k2 $k3 20 $j -psm example/psm.txt -wl ../wl_gen/wl_normal.txt -res results/history/case3.txt >> results/history/case3_sim.txt
		done
echo "[init] Exponential distribution"
		for j in {0..500..10}
		do
			./dpm_simulator -h $k1 $k2 $k3 100 $j -psm example/psm.txt -wl ../wl_gen/wl_exp.txt -res results/history/case4.txt >> results/history/case4_sim.txt
		done
echo "[init] Tri-modal distribution"
		for j in {0..200..4}
		do
			./dpm_simulator -h $k1 $k2 $k3 40 $j -psm example/psm.txt -wl ../wl_gen/wl_tri.txt -res results/history/case5.txt >> results/history/case5_sim.txt
		done
echo "[init] Custom workload 1"
		for j in {0..400..8}
		do
			./dpm_simulator -h $k1 $k2 $k3 80 $j -psm example/psm.txt -wl ../custom_workloads/custom_workload_1.txt -res results/history/custom1.txt >> results/history/custom1_sim.txt
		done
echo "[init] Custom workload 2"
		for j in {0..400..8}
		do
			./dpm_simulator -h $k1 $k2 $k3 80 $j -psm example/psm.txt -wl ../custom_workloads/custom_workload_2.txt -res results/history/custom2.txt >> results/history/custom2_sim.txt
		done

echo "\n[sys] OK!"
