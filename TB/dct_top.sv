//Have to include uvm macros before compiling your class files
`include "uvm_macros.svh"
import uvm_pkg::*;

//I have include all the class files here
//So  when this line is executed the sv files will be  compiled in the order its listed
`include "dct.v"
`include "dct_include.svh"

module dct_top;
	bit clock,reset;
	
	always #5 clock=~clock;
	
	initial begin
		reset=1;
		#10 reset=0;
	end
	
	dct_intf i(clock,reset);
	dct DUT(.CLK(i.clock),.RST(i.reset),.xin(i.xin),.dct_2d(i.dct_2d),.rdy_out(i.ready_out),.z_out(i.zout));
	
	initial begin
		uvm_config_db#(virtual dct_intf)::set(null,"*","dct_intf",i);
		run_test("dct_test");
	end
endmodule:dct_top