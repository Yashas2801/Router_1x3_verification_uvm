class dest_seqs_base extends uvm_sequence #(dest_xtn);
  `uvm_object_utils(dest_seqs_base)

  extern function new(string name = "dest_seqs_base");
endclass

function dest_seqs_base::new(string name = "dest_seqs_base");
  super.new(name);
endfunction


class small_delay extends dest_seqs_base;
  `uvm_object_utils(small_delay)

  extern function new(string name = "small_delay");
  extern task body;
endclass

function small_delay::new(string name = "small_delay");
  super.new(name);

endfunction

task small_delay::body;
  req = dest_xtn::type_id::create("req");
  start_item(req);
  `uvm_info(get_type_name, "start_item unblocked", UVM_LOW)
  assert (req.randomize with {delay inside {[1 : 15]};});
  finish_item(req);
  `uvm_info(get_type_name, "finish_item unblocked", UVM_LOW)
endtask



class medium_delay extends dest_seqs_base;
  `uvm_object_utils(medium_delay)

  extern function new(string name = "medium_delay");
  extern task body;
endclass

function medium_delay::new(string name = "medium_delay");
  super.new(name);

endfunction

task medium_delay::body;
  req = dest_xtn::type_id::create("req");
  start_item(req);
  `uvm_info(get_type_name, "start_item unblocked", UVM_LOW)
  assert (req.randomize with {delay inside {[16 : 29]};});
  finish_item(req);
  `uvm_info(get_type_name, "finish_item unblocked", UVM_LOW)
endtask



class large_delay extends dest_seqs_base;
  `uvm_object_utils(large_delay)

  extern function new(string name = "large_delay");
  extern task body;
endclass

function large_delay::new(string name = "large_delay");
  super.new(name);

endfunction

task large_delay::body;
  req = dest_xtn::type_id::create("req");
  start_item(req);
  `uvm_info(get_type_name, "start_item unblocked", UVM_LOW)
  assert (req.randomize with {delay inside {40};});
  finish_item(req);
  `uvm_info(get_type_name, "finish_item unblocked", UVM_LOW)
endtask
