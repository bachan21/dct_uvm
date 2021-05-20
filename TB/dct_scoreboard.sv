
 class dct_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(dct_scoreboard)

	//Analysis ports
	uvm_analysis_imp #(dct_sequence_item,dct_scoreboard) ap_imp;
	
	//Queue for storing
	//dct_sequence_item q[$];
	mailbox#(dct_sequence_item) MB;
	
	//Ref Model
	dct_ref_model M0;
	
	int data_verified=0;
	int pass=0;
	int fail=0;
	
    extern function new(string name="DCT_SCOREBOARD",uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern virtual function void check_phase(uvm_phase phase);
	extern virtual function void write(dct_sequence_item item);
	extern virtual task process();
 endclass : dct_scoreboard
 
 function dct_scoreboard :: new(string name="DCT_SCOREBOARD",uvm_component parent);
	super.new(name,parent);
	MB = new();
 endfunction : new
 
 function void dct_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	//Build Analysis port
	ap_imp = new("AP_IMP",this);
	
	//Build Ref Model
	M0 = dct_ref_model::type_id::create("REF_MODEL");
 endfunction : build_phase
 
 function void dct_scoreboard ::write(dct_sequence_item item);
	`uvm_info(get_name(),{"\nOBSERVED OUTPUTS ::\n",item.convert2string},UVM_LOW)
	void '(MB.try_put(item));
 endfunction : write

 task dct_scoreboard::run_phase(uvm_phase phase);
	super.run_phase(phase);
	process();
 endtask:run_phase
 
 task dct_scoreboard::process();
	dct_sequence_item item;
	dct_sequence_item pkt ;
	forever begin
		item = dct_sequence_item::type_id::create("item");
		MB.get(item);
		//	`uvm_info(get_full_name(),{"\nITEM ::\n",item.convert2string()},UVM_LOW)
			
		pkt = dct_sequence_item::type_id::create("PKT");
		
		pkt.copy(item);
		
		M0.dct_process(pkt); //expected
			`uvm_info(get_name(),{"\nEXPECTED ::\n",pkt.convert2string()},UVM_LOW)
		
		if(item.compare(pkt)) begin
			`uvm_info(get_name(),"Match",UVM_LOW)
			pass++;
		end
		
		else begin
			`uvm_info(get_name(),"Mismatch",UVM_LOW)
			fail++;
		end
		data_verified++;
	end
 endtask
 
 function void dct_scoreboard::check_phase(uvm_phase phase);
	super.check_phase(phase);
	`uvm_info(get_full_name(),$sformatf("Sequence Processed = %0d, Pass = %0d, Fail=%0d",data_verified,pass,fail),UVM_LOW)
 endfunction:check_phase