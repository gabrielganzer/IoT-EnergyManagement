# Energy Management for IoT
[![SHIELDS](https://img.shields.io/badge/development-completed-green)](https://shields.io/)

## PROJECT DESCRIPTION

### Dynamic Power Management

This project consisted of applying Dynamic Power Management (DPM) on a series of worloaks by simulating and modifying a Power State Machine (PSM) written in C language. The manager implements two strategies:
	* Timeout Policy, that keeps the system in a high power consuming Run state even after activity has ceased, transitioning to a low power state only after a certain threshold is reached, i.e., the timeout value.
	* History Policy, that is a predictive policy, i.e., it estimates the time to transition based on the previous workload patterns. The computed value Tpred is compared to the time to Idle and Sleep thresholds. After a decision is taken the system is able to reach any one of the low-power states independently.

### Energy efficient image processing

Evaluation of several image transformations used in Organic Light-Emitting Diode (OLED) displays as a mean of reducing power consumption. Compensation techniques are also used in conjunction with Dynamic Voltage Scaling (DVS) for the same goal.

### Energy storage, generation and conversion

Simulation of an IoT device in MATLAB/Simulink. The model consisted of a System-on-Chip (SoC) for measuring urban polution, integrating an the following sensors: air quality, methane level, temperature, and noise. A subsequent analysis of its behavior in terms of power perspective and possible optimizations to increase the system lifetime are provided.

## DOCUMENTATION

Further explanations can be found in the file *"report.pdf"* located inside each respective folder.