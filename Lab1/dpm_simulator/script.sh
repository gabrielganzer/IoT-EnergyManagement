echo "[script] Initializing...\n"
mkdir -p results/DPM
echo "[init] Uniform distribution - High utilization"
for i in {0..100..2}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_high.txt -res results/DPM/case1.txt >> results/DPM/case1_sim.txt
done
echo "[done] Uniform distribution - High utilization\n"
echo "[init] Uniform distribution - Low utilization"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_low.txt -res results/DPM/case2.txt >> results/DPM/case2_sim.txt
done
echo "[done] Uniform distribution - Low utilization\n"
echo "[init] Normal distribution"
for i in {0..200..4}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_normal.txt -res results/DPM/case3.txt >> results/DPM/case3_sim.txt
done
echo "[done] Normal distribution\n"
echo "[init] Exponential distribution"
for i in {0..500..10}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_exp.txt -res results/DPM/case4.txt >> results/DPM/case4_sim.txt
done
echo "[done] Exponential distribution\n"
echo "[init] Tri-modal distribution"
for i in {0..200..4}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_tri.txt -res results/DPM/case5.txt >> results/DPM/case5_sim.txt
done
echo "[done] Tri-modal distribution\n"
echo "[init] Tri-modal distribution"
for i in {0..200..4}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_tri.txt -res results/DPM/case5.txt >> results/DPM/case5_sim.txt
done
echo "[done] Tri-modal distribution\n"
echo "[init] Custom workload 1"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../custom_workloads/custom_workload_1.txt -res results/DPM/custom1.txt >> results/DPM/custom1_sim.txt
done
echo "[done] Custom workload 1\n"
echo "[init] Custom workload 2"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../custom_workloads/custom_workload_2.txt -res results/DPM/custom2.txt >> results/DPM/custom2_sim.txt
done
echo "[done] Custom workload 2\n"
echo "[script] OK!"
