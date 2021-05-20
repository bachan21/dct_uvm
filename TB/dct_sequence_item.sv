 
class dct_sequence_item extends uvm_sequence_item;
	rand bit signed [7:0] xin [8][8];
	bit signed [11:0] dct_2d [8][8];
	bit signed [10:0] zout [8][8];
	
	//string TAG;
	
	`uvm_object_utils(dct_sequence_item)
	extern function new(string name="DCT_SEQUENCE_ITEM");
	extern virtual function string convert2string(); 
	extern virtual function bit do_compare(uvm_object rhs, uvm_comparer);
	extern virtual function void do_copy(uvm_object rhs);
endclass : dct_sequence_item


function dct_sequence_item::new(string name="DCT_SEQUENCE_ITEM"); 
	super.new(name);
endfunction : new

function string dct_sequence_item::convert2string ();
  string s;
  s = {s, $sformatf("\nxin ->\n")};
  for(int i=0;i<8;i++) begin
	for(int j=0;j<8;j++) 
		s = {s,$sformatf("%0d  ",xin[i][j])};
	s = {s,$sformatf("\n")};
  end
  s = {s, $sformatf("\nzout ->\n")};
  for(int i=0;i<8;i++) begin 
	for(int j=0;j<8;j++) 
		s = {s,$sformatf("%0d  ",zout[i][j])};
	s = {s,$sformatf("\n")};
  end	
  s = {s, $sformatf("\ndct->\n")};
  for(int i=0;i<8;i++) begin 
	for(int j=0;j<8;j++) 
		s = {s,$sformatf("%0d  ",dct_2d[i][j])};
	s = {s,$sformatf("\n")};
  end
  return s;
endfunction:convert2string

function bit dct_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
	bit res=0;
	dct_sequence_item obj;
	$cast(obj,rhs);
	
	res = super.do_compare(obj,comparer);
	
	for(int i=0;i<8;i++)
		for(int j=0;j<8;j++) 
			if(xin[i][j]!=obj.xin[i][j])
			return 0;
	
	for(int i=0;i<8;i++)
		for(int j=0;j<8;j++) 
			if(zout[i][j]!=obj.zout[i][j])
			return 0;
			
	for(int i=0;i<8;i++)
		for(int j=0;j<8;j++) 
			if(dct_2d[i][j]!=obj.dct_2d[i][j])
			return 0;

	return 1;
endfunction:do_compare

function void dct_sequence_item::do_copy(uvm_object rhs);
	dct_sequence_item _pkt;
	$cast(_pkt, rhs);
	
	xin = _pkt.xin;
	dct_2d = _pkt.dct_2d;
	zout = _pkt.zout;
endfunction:do_copy