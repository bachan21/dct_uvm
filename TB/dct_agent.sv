import uvm_pkg::*;

class dct_agent extends uvm_agent;
    `uvm_component_utils(dct_agent)
	virtual dct_intf vif;
	
	//Declare components
	dct_sequencer sequencer;
	dct_driver driver;
	dct_monitor monitor;
	
    extern function new(string name="DCT_AGENT",uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
  endclass : dct_agent
  
 function dct_agent :: new(string name="DCT_AGENT",uvm_component parent);
	super.new(name,parent);
 endfunction : new
 
 function void dct_agent :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	//Get virtual interface using uvm_config_db
	if(!uvm_config_db#(virtual dct_intf) :: get(this,"","dct_intf",vif))
		`uvm_fatal(get_full_name(),"virtual interface is not obtained for agent");
		
	//Construct components
	sequencer = dct_sequencer::type_id::create("DCT_SEQUENCER",this);
	driver = dct_driver::type_id::create("DCT_DRIVER",this);
	monitor = dct_monitor::type_id::create("DCT_MONITOR",this);
 endfunction : build_phase
 
 function void dct_agent :: connect_phase(uvm_phase phase);
	driver.seq_item_port.connect(sequencer.seq_item_export);
 endfunction : connect_phase