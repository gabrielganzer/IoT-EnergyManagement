#!/bin/sh
echo "[sys] Initializing..."
mkdir -p results/timeout_DPM
mkdir -p results/timeout_DPMextended
echo "\n[sys] Simulations using PSM w/o SLEEP transtion"
echo "[init] Uniform distribution - High utilization"
for i in {0..100..2}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../workloads/wl_high.txt -res results/timeout_DPM/case1.txt >> results/timeout_DPM/case1_sim.txt
done
echo "[init] Uniform distribution - Low utilization"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../workloads/wl_low.txt -res results/timeout_DPM/case2.txt >> results/timeout_DPM/case2_sim.txt
done
echo "[init] Normal distribution"
for i in {0..200..4}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../workloads/wl_normal.txt -res results/timeout_DPM/case3.txt >> results/timeout_DPM/case3_sim.txt
done
echo "[init] Exponential distribution"
for i in {0..500..10}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../workloads/wl_exp.txt -res results/timeout_DPM/case4.txt >> results/timeout_DPM/case4_sim.txt
done
echo "[init] Tri-modal distribution"
for i in {0..200..4}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../workloads/wl_tri.txt -res results/timeout_DPM/case5.txt >> results/timeout_DPM/case5_sim.txt
done
echo "[init] Custom workload 1"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../workloads/custom_workload_1.txt -res results/timeout_DPM/custom1.txt >> results/timeout_DPM/custom1_sim.txt
done
echo "[init] Custom workload 2"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../workloads/custom_workload_2.txt -res results/timeout_DPM/custom2.txt >> results/timeout_DPM/custom2_sim.txt
done
echo "\n[sys] Simulations using PSM w/ SLEEP transtion"
echo "[init] Uniform distribution - High utilization"
	for i in {0..100..2}
	do
		for j in {0..100..2}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../workloads/wl_high.txt -res results/timeout_DPMextended/case1.txt >> results/timeout_DPMextended/case1_sim.txt
		done
	done
echo "[init] Uniform distribution - Low utilization"
	for i in {0..400..8}
	do
		for j in {0..400..8}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../workloads/wl_low.txt -res results/timeout_DPMextended/case2.txt >> results/timeout_DPMextended/case2_sim.txt
		done
	done
echo "[init] Normal distribution"
	for i in {0..200..4}
	do
		for j in {0..200..4}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../workloads/wl_normal.txt -res results/timeout_DPMextended/case3.txt >> results/timeout_DPMextended/case3_sim.txt
		done
	done
echo "[init] Exponential distribution"
	for i in {0..500..10}
	do
		for j in {0..500..10}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../workloads/wl_exp.txt -res results/timeout_DPMextended/case4.txt >> results/timeout_DPMextended/case4_sim.txt
		done
	done
echo "[init] Tri-modal distribution"
	for i in {0..200..4}
	do
		for j in {0..200..4}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../workloads/wl_tri.txt -res results/timeout_DPMextended/case5.txt >> results/timeout_DPMextended/case5_sim.txt
		done
	done
echo "[init] Custom workload 1"
	for i in {0..400..8}
	do
		for j in {0..400..8}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../workloads/custom_workload_1.txt -res results/timeout_DPMextended/custom1.txt >> results/timeout_DPMextended/custom1_sim.txt
		done
	done
echo "[init] Custom workload 2"
	for i in {0..400..8}
	do
		for j in {0..400..8}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../workloads/custom_workload_2.txt -res results/timeout_DPMextended/custom2.txt >> results/timeout_DPMextended/custom2_sim.txt
		done
	done
echo "\n[sys] OK!"
