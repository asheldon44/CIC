
cwd = ${shell pwd}

OPT=

sim:
	mkdir -p data
	python ./analysis_src/generateinput.py
	iverilog -o ./data/CIC.vvp ./verilog_src/CIC_tb.v 
	vvp ./data/CIC.vvp
	python ./analysis_src/analyze_output.py

gtk:
	gtkwave ./data/signals.vcd

clean:
	rm -f ./data/CIC.vvp
	rm -f ./data/signals.vcd
	rm -f ./data/bitstream.txt	
	rm -rf ./data
