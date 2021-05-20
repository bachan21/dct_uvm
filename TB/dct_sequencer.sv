
 class dct_sequencer extends uvm_sequencer#(dct_sequence_item);
	`uvm_component_utils(dct_sequencer)
    extern function new(string name="DCT_SEQUENCER",uvm_component parent);
 endclass : dct_sequencer
 
 function dct_sequencer:: new(string name="DCT_SEQUENCER",uvm_component parent);
	super.new(name,parent);
 endfunction : new