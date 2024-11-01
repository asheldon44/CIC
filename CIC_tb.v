`include "CIC.v"

`timescale 10ps/10ps

module CIC_tb;
	reg               clk;
	reg               rst;
	reg        [15:0] decimation_ratio;
	reg signed  d_in;
	wire signed [30:0]  d_out;
	wire 			   d_clk;
	
	integer x_in, x_read;
	
	CIC #(.width(18)) CIC(.clk(clk),
						   .rst(rst),
						   .decimation_ratio(decimation_ratio),
						   .d_in(d_in),
						   .d_out(d_out),
						   .d_clk(d_clk));
		   
	always #3125 clk = ~clk;
	
	initial
	begin
		clk <= 1'b0;
		rst <= 1'b0;
		decimation_ratio <= 16'd64;
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
