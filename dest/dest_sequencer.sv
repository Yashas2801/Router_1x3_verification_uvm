	class dest_sequencer extends uvm_sequencer#(dest_xtn);
		`uvm_component_utils(dest_sequencer)
		extern function new(string name,uvm_component parent);
	endclass

	function dest_sequencer::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
