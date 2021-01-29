# Pentium4 Register File
[![SHIELDS](https://img.shields.io/badge/development-completed-green)](https://shields.io/)

## PROJECT DESCRIPTION

Simple register file based on the Pentium4 Integer RF with the following specifications:

* 32 registers
* bitwidth = 64 bit
* 1 write port
* 2 read ports
* synchronous R/W on the clock rising edge if R1/R2/W signal active (high)
* synchronous reset
* enable signal active high
* simultaneous Read and Write capabilities

## DOCUMENTATION

Folder *sim* contains the VHDL files used during simulation. Folder *sys* instead reports the results obtanied during synthesis.

## LICENSE

The source code of the project is licensed under the GPLv3 license, unless otherwise stated.
