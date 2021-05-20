 
class dct_test extends uvm_test;
	`uvm_component_utils(dct_test)
	
	dct_env env;
	virtual dct_intf vif;
	
    extern function new(string name="DCT_TEST",uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void end_of_elaboration_phase(uvm_phase phase);	
	extern virtual task run_phase(uvm_phase phase);
endclass : dct_test
 
 function dct_test :: new(string name="DCT_TEST",uvm_component parent=null);
	super.new(name,parent);
 endfunction:new
 
function void dct_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
/* 	//Get virtual interface using uvm_config_db
	if(!uvm_config_db#(virtual dct_intf)::get(this,"*","dct_intf",vif))
		`uvm_fatal(get_full_name(),"virtual interface is not obtained for test"); */
	
	//Construct components
	env=dct_env::type_id::create("DCT_ENV",this);
 endfunction:build_phase
 
 function void dct_test :: end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
 endfunction:end_of_elaboration_phase
 
 task dct_test :: run_phase(uvm_phase phase);
	dct_sequence seq = dct_sequence::type_id::create("DCT_SEQUENCE");
	phase.raise_objection(this);
		repeat(1)
			seq.start(env.agent.sequencer);
		phase.phase_done.set_drain_time(this,1500ns);
	phase.drop_objection(this);
 endtask:run_phase