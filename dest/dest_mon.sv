class dest_mon extends uvm_monitor;
  `uvm_component_utils(dest_mon)

  virtual rtr_if.DST_MON_MP vif;
  dest_config d_cfg;
  uvm_analysis_port #(dest_xtn) ana_port;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data;

endclass

function dest_mon::new(string name, uvm_component parent);
  super.new(name, parent);
  ana_port = new("ana_port", this);
endfunction

function void dest_mon::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of dest_mon", UVM_LOW)

  if (!uvm_config_db#(dest_config)::get(this, "", "dest_config", d_cfg))
    `uvm_fatal(get_type_name, "faild to get dest_config in dest_mon")
endfunction

function void dest_mon::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  `uvm_info(get_type_name, "In the connect phase of dest mon", UVM_LOW)

  vif = d_cfg.vif;
endfunction

task dest_mon::run_phase(uvm_phase phase);
  `uvm_info(get_type_name, "In the run phase of dest_mon", UVM_INFO)
  forever collect_data;
endtask

task dest_mon::collect_data;

  dest_xtn xtn;
  xtn = dest_xtn::type_id::create("xtn");

  //NOTE: waiting for read enable to go high
  wait (vif.dst_mon_cb.read_en);

  // After a clock cycle delay, sample header
  @(vif.dst_mon_cb);
  xtn.header  = vif.dst_mon_cb.data_out;

  //setting payload length by observing sampled header
  xtn.payload = new[xtn.header[7:2]];

  // After a clock cycle delay, sample all the payloads using foreach loop
  @(vif.dst_mon_cb);
  foreach (xtn.payload[i]) begin
    xtn.payload[i] = vif.dst_mon_cb.data_out;
    @(vif.dst_mon_cb);  //NOTE: Each payload is sampeled from data_out at each clock cycle
  end

  xtn.parity = vif.dst_mon_cb.data_out;
  @(vif.dst_mon_cb);

  `uvm_info(get_type_name, $sformatf("Data monitered in dst mon is \n %s", xtn.sprint), UVM_LOW)

  ana_port.write(xtn);
endtask
