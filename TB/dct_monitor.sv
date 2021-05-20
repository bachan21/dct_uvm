
class dct_monitor extends uvm_monitor;
	`uvm_component_utils(dct_monitor)
	
	mailbox#(dct_sequence_item) mbx;
	mailbox#(dct_sequence_item) mbz;
	mailbox#(dct_sequence_item) mbdct;
	virtual dct_intf vif;
	
	uvm_analysis_port #(dct_sequence_item) mon_port;
	
    extern function new(string name="DCT_MONITOR",uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);	
	extern virtual task run_phase(uvm_phase phase);
	extern virtual task read_xin();
	extern virtual task read_zout;
	extern virtual task read_dct_2d(); 
endclass : dct_monitor
 



function dct_monitor:: new(string name="DCT_MONITOR",uvm_component parent);
	super.new(name,parent);
 endfunction : new
 
function void dct_monitor :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual dct_intf) :: get(this,"","dct_intf",vif))
		`uvm_fatal(get_full_name(),"virtual interface is not obtained for monitor");
		
	mon_port = new("MON_PORT",this);
	mbx = new();
	mbz = new();
	mbdct = new();
endfunction : build_phase
 
task dct_monitor :: run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	fork
		read_xin();
		read_zout();
		read_dct_2d();
	join
 endtask : run_phase

task dct_monitor :: read_xin();
	forever begin
	dct_sequence_item item_xin = dct_sequence_item::type_id::create("ITEM_XIN");
	
	wait(!vif.reset)
	for(int i=0;i<8;i++) begin
		for(int j=0;j<8;j++) begin
			@(vif.cb_mon)
			item_xin.xin[i][j] = vif.xin;
		end
	end
	//`uvm_info(get_full_name(),$sformatf({"\nRecieved Xin in monitor",item_xin.convert2string()}),UVM_LOW)	
	mbx.put(item_xin);
	end
endtask:read_xin

task dct_monitor :: read_zout();
	dct_sequence_item item_zout;
	dct_sequence_item item_xin;
	
	//wait for reset to be deasserted
	wait(!vif.reset)
	
	//wait for 14 clock cycles
	for(int i=0;i<14;i++) begin
		@vif.cb_mon;
	end
	
	forever begin
	
	item_zout = dct_sequence_item::type_id::create("ITEM_ZOUT");
	
	for(int i=0;i<8;i++) begin
		for(int j=0;j<8;j++) begin
			item_zout.zout[i][j] = vif.zout;
			@(vif.cb_mon);
		end
	end
	
	mbz.put(item_zout);
	//`uvm_info(get_full_name(),$sformatf({"\nRecieved Xin in monitor",item_xin.convert2string()}),UVM_LOW)
	
	/* item_xin = dct_sequence_item::type_id::create("ITEM_XIN");
	item_xin=x_q.pop_front();
	
	for(int i=0;i<64;i++)
		item_zout.xin[i] = item_xin.xin[i];
		
	mon_port.write(item_zout); */
	end 
	
endtask:read_zout
 
task dct_monitor :: read_dct_2d();
	dct_sequence_item item_dct;
	dct_sequence_item item;
	dct_sequence_item temp;
	
	forever begin
	item_dct = dct_sequence_item::type_id::create("ITEM_DCT");
	
	wait(!vif.reset);
	wait(vif.ready_out);
	for(int i=0;i<8;i++) begin
		for(int j=0;j<8;j++) begin
			@(vif.cb_mon)
			item_dct.dct_2d[i][j] = vif.dct_2d;
		end
	end
	//`uvm_info(get_full_name(),$sformatf({"\nRecieved DCT in monitor::\nDCT value",item_dct.convert2string()}),UVM_LOW)
	mbdct.put(item_dct);
	
	item = dct_sequence_item::type_id::create("ITEM");
	
	mbx.get(temp);
	//Fill x  values
	for(int i=0;i<8;i++)
		for(int j=0;j<8;j++)
			item.xin[i][j] = temp.xin[i][j];
		
	mbz.get(temp);
	//Fill Z values
	for(int i=0;i<8;i++)
		for(int j=0;j<8;j++)
			item.zout[i][j] = temp.zout[i][j];
		
	mbdct.get(temp);
	//Fill dct values
	for(int i=0;i<8;i++)
		for(int j=0;j<8;j++)
			item.dct_2d[i][j] = temp.dct_2d[i][j];
		
	mon_port.write(item);
	end
endtask : read_dct_2d
	