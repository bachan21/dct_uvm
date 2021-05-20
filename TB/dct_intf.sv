interface dct_intf(input clock,reset);
logic [7:0] xin;
logic [10:0] zout;
logic [11:0] dct_2d;
logic ready_out;

clocking cb_drv @(posedge clock);
	default input #1step output #0;
	output xin;
	input dct_2d,ready_out,zout;
endclocking : cb_drv

clocking cb_mon @(posedge clock);
	default input #1step output #0;
	input zout,dct_2d,ready_out,xin;
endclocking : cb_mon

endinterface : dct_intf