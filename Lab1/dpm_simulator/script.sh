echo "[sys] Initializing..."
mkdir -p results/DPM
mkdir -p results/DPM_extended
echo "\n[sys] Simulations using PSM w/o SLEEP transtion"
echo "[init] Uniform distribution - High utilization"
for i in {0..100..2}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_high.txt -res results/DPM/case1.txt >> results/DPM/case1_sim.txt
done
echo "[init] Uniform distribution - Low utilization"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_low.txt -res results/DPM/case2.txt >> results/DPM/case2_sim.txt
done
echo "[init] Normal distribution"
for i in {0..200..4}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_normal.txt -res results/DPM/case3.txt >> results/DPM/case3_sim.txt
done
echo "[init] Exponential distribution"
for i in {0..500..10}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_exp.txt -res results/DPM/case4.txt >> results/DPM/case4_sim.txt
done
echo "[init] Tri-modal distribution"
for i in {0..200..4}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../wl_gen/wl_tri.txt -res results/DPM/case5.txt >> results/DPM/case5_sim.txt
done
echo "[init] Custom workload 1"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../custom_workloads/custom_workload_1.txt -res results/DPM/custom1.txt >> results/DPM/custom1_sim.txt
done
echo "[init] Custom workload 2"
for i in {0..400..8}
	do
	./dpm_simulator -t $i -psm example/psm.txt -wl ../custom_workloads/custom_workload_2.txt -res results/DPM/custom2.txt >> results/DPM/custom2_sim.txt
done
echo "\n[sys] Simulations using PSM w/ SLEEP transtion"
echo "[init] Uniform distribution - High utilization"
for i in {0..100..20}
	do
		for j in {0..100..10}
			do
				./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../wl_gen/wl_high.txt -res results/DPM_extended/case1.txt >> results/DPM_extended/case1_sim.txt
			done
done
echo "[init] Uniform distribution - Low utilization"
for i in {0..400..80}
	do
		for j in {0..400..40}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../wl_gen/wl_low.txt -res results/DPM_extended/case2.txt >> results/DPM_extended/case2_sim.txt
		done
done
echo "[init] Normal distribution"
for i in {0..200..40}
	do
		for j in {0..200..20}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../wl_gen/wl_normal.txt -res results/DPM_extended/case3.txt >> results/DPM_extended/case3_sim.txt
		done
done
echo "[init] Exponential distribution"
for i in {0..500..100}
	do
		for j in {0..500..50}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../wl_gen/wl_exp.txt -res results/DPM_extended/case4.txt >> results/DPM_extended/case4_sim.txt
		done
done
echo "[init] Tri-modal distribution"
for i in {0..200..40}
	do
		for j in {0..200..20}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../wl_gen/wl_tri.txt -res results/DPM_extended/case5.txt >> results/DPM_extended/case5_sim.txt
		done
done
echo "[init] Custom workload 1"
for i in {0..400..80}
	do
		for j in {0..400..40}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../custom_workloads/custom_workload_1.txt -res results/DPM_extended/custom1.txt >> results/DPM_extended/custom1_sim.txt
		done
done
echo "[init] Custom workload 2"
for i in {0..400..80}
	do
		for j in {0..400..40}
		do
			./dpm_simulator -t $i $j -psm example/psm_extended.txt -wl ../custom_workloads/custom_workload_2.txt -res results/DPM_extended/custom2.txt >> results/DPM_extended/custom2_sim.txt
		done
done

echo "\n[sys] OK!"
