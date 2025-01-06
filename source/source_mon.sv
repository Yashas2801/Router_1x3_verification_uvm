class source_mon extends uvm_monitor;
  `uvm_component_utils(source_mon)

  virtual rtr_if.SRC_MON_MP vif;
  source_config s_cfg;
  uvm_analysis_port #(source_xtn) ana_port;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task sample_data;

endclass

function source_mon::new(string name, uvm_component parent);
  super.new(name, parent);
  ana_port = new("ana_port", this);
endfunction

function void source_mon::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of src_mon", UVM_LOW)

  if (!uvm_config_db#(source_config)::get(this, "", "source_config", s_cfg))
    `uvm_fatal(get_type_name, "failed to get source config in source mon")
endfunction

function void source_mon::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  `uvm_info(get_type_name, "In the connect_phase of source mon", UVM_LOW)

  vif = s_cfg.vif;
endfunction

task source_mon::run_phase(uvm_phase phase);
  forever sample_data;
endtask

task source_mon::sample_data;
  source_xtn xtn;
  xtn = source_xtn::type_id::create("xtn");

  //  @(vif.src_mon_cb);  //NOTE: we use this delay if we use while loop(use the delay both in mon and driver)

  wait (!vif.src_mon_cb.busy);
  wait (vif.src_mon_cb.pkt_valid);
  xtn.header  = vif.src_mon_cb.data_in;
  xtn.payload = new[xtn.header[7:2]];

  @(vif.src_mon_cb);

  foreach (xtn.payload[i]) begin
    wait (!vif.src_mon_cb.busy);
    xtn.payload[i] = vif.src_mon_cb.data_in;
    @(vif.src_mon_cb);
  end

  xtn.parity = vif.src_mon_cb.data_in;

  repeat (2) @(vif.src_mon_cb);

  xtn.busy = vif.src_mon_cb.busy;
  xtn.err  = vif.src_mon_cb.err;

  `uvm_info(get_type_name, $sformatf("Xtn moniterd in src mon \n %s", xtn.sprint), UVM_LOW)

  ana_port.write(xtn);

endtask

