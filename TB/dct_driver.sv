
 class dct_driver extends uvm_driver#(dct_sequence_item);
	`uvm_component_utils(dct_driver)
	virtual dct_intf vif;
	dct_sequence_item item;
	
    extern function new(string name="DCT_DRIVER",uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern virtual task drive_item(dct_sequence_item item);
 endclass : dct_driver
 
 function dct_driver :: new(string name="DCT_DRIVER",uvm_component parent);
	super.new(name,parent);
 endfunction : new
 
 function void dct_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual dct_intf) :: get(this,"","dct_intf",vif))
		`uvm_fatal(get_full_name(),"virtual interface is not obtained for driver")
 endfunction : build_phase
 
 task dct_driver :: run_phase(uvm_phase phase);
    super.run_phase(phase);
	forever begin
		seq_item_port.get_next_item(item);
		`uvm_info(get_name(),$sformatf(item.convert2string()),UVM_LOW)	
		drive_item(item);
		seq_item_port.item_done();
	end
 endtask : run_phase
 
 task dct_driver :: drive_item(dct_sequence_item item);
	wait(!vif.reset);
	for(int i=0;i<8;i++) begin
		for(int j=0;j<8;j++)
		if(!vif.reset)begin
			vif.xin <= item.xin[i][j];
			@(vif.cb_drv);
		end
	end

	/* else
		vif.xin <= 0; */
	
 endtask : drive_item
 
 