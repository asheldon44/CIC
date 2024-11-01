
cwd = ${shell pwd}

OPT=

sim:
	python ./generateinput.py
	iverilog -o CIC.vvp CIC_tb.v 
	vvp CIC.vvp
	python ./analyze_output.py

gtk:
	gtkwave ./signals.vcd
