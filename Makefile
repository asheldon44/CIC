
cwd = ${shell pwd}

OPT=

sim:
	python ./analysis_src/generateinput.py
	iverilog -o ./data/CIC.vvp ./verilog_src/CIC_tb.v 
	vvp ./data/CIC.vvp
	python ./analysis_src/analyze_output.py

gtk:
	gtkwave ./data/signals.vcd
