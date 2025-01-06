	class source_sequencer extends uvm_sequencer#(source_xtn);
		`uvm_component_utils(source_sequencer)
		extern function new(string name,uvm_component parent);
	endclass

	function source_sequencer::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
