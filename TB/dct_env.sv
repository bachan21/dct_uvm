 class dct_env extends uvm_env;
	`uvm_component_utils(dct_env)
	dct_agent agent;
	dct_scoreboard scoreboard;
	
    extern function new(string name="DCT_ENV",uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
endclass : dct_env
 
 function dct_env :: new(string name="DCT_ENV",uvm_component parent);
	super.new(name,parent);
 endfunction : new
 
 function void dct_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
		
	//Construct components
	agent=dct_agent::type_id::create("DCT_AGENT",this);
	scoreboard=dct_scoreboard::type_id::create("DCT_SCOREBOARD",this);
 endfunction : build_phase
 
 function void dct_env :: connect_phase(uvm_phase phase);
	agent.monitor.mon_port.connect(scoreboard.ap_imp);
 endfunction : connect_phase