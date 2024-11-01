`include "./verilog_src/CIC.v"

`timescale 10ps/10ps

module CIC_tb;
    reg clk;
    reg dec_clk;
    reg rst;
    reg d_in;
    wire [23:0] d_out;

	integer x_in, x_read;
	
	CIC CIC(.clk(clk),
			.dec_clk(dec_clk),
			.rst(rst),
			.in(d_in),
			.out(d_out));
		   
	always #3125 clk = ~clk;

	always #200000 dec_clk = ~dec_clk;
	
	initial
	begin
		clk <= 1'b0;
		dec_clk <= 1'b0;
		rst <= 1'b0;
		d_in <= 1'b0;
		x_in <= $fopen("bitstream.txt","r");
		$dumpfile("signals.vcd"); // Name of the signal dump file
    	$dumpvars(0, CIC_tb); // Signals to dump
	end 
	
	initial
	begin
		repeat(10) @(posedge clk);
		rst <= 1'b1;
		@(posedge clk);
		rst <= 1'b0;
		repeat(5) @(posedge clk);
		while (!$feof(x_in))
		begin
			x_read <= $fscanf(x_in,"%d\n",d_in);
			@(posedge clk);
		end
		repeat(5) @(posedge clk);
		$fclose(x_in);
		$finish();
	end
endmodule
