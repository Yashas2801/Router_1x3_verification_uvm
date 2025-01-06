class source_seqs_base extends uvm_sequence #(source_xtn);
  `uvm_object_utils(source_seqs_base)

  bit [1:0] addr;
  extern function new(string name = "source_seqs_base");
  extern task body;
endclass

function source_seqs_base::new(string name = "source_seqs_base");
  super.new(name);
endfunction

task source_seqs_base::body();
  if (!uvm_config_db#(bit [1:0])::get(null, get_full_name(), "addr1", addr))
    `uvm_fatal(get_type_name, "failed to get addr in source seq")

  `uvm_info(get_type_name, $sformatf("Addr in src_side is %b", addr), UVM_LOW)
endtask

class small_xtn extends source_seqs_base;
  `uvm_object_utils(small_xtn)

  extern function new(string name = "small_xtn");
  extern task body;

endclass

function small_xtn::new(string name = "small_xtn");
  super.new(name);
endfunction

task small_xtn::body;
  super.body;
  req = source_xtn::type_id::create("req");
  start_item(req);
  `uvm_info(get_type_name, "start_item unblocked", UVM_LOW)
  assert (req.randomize with {
    header[7:2] inside {[1 : 14]};
    header[1:0] == addr;
  });
  req.parity = 0;  //NOTE: Introducing a parity error
  finish_item(req);
  `uvm_info(get_type_name, "finish item unblocked", "UVM_LOW")
endtask


class medium_xtn extends source_seqs_base;
  `uvm_object_utils(medium_xtn)

  extern function new(string name = "medium_xtn");
  extern task body;
endclass

function medium_xtn::new(string name = "medium_xtn");
  super.new(name);
endfunction

task medium_xtn::body;
  super.body;
  req = source_xtn::type_id::create("req");
  start_item(req);
  `uvm_info(get_type_name, "unblocked start_item", UVM_LOW)
  assert (req.randomize with {
    header[7:2] inside {[15 : 40]};
    header[1:0] == addr;
  });
  finish_item(req);
  `uvm_info(get_type_name, "finish item unblocked", UVM_LOW);
endtask


class large_xtn extends source_seqs_base;
  `uvm_object_utils(large_xtn)

  extern function new(string name = "large_xtn");
  extern task body;
endclass

function large_xtn::new(string name = "large_xtn");
  super.new(name);
endfunction

task large_xtn::body;
  super.body;
  req = source_xtn::type_id::create("req");
  start_item(req);
  `uvm_info(get_type_name, "unblocked start_item", UVM_LOW)
  assert (req.randomize with {
    header[7:2] inside {[41 : 63]};
    header[1:0] == addr;
  });
  finish_item(req);
  `uvm_info(get_type_name, "finish item unblocked", UVM_LOW);
endtask























