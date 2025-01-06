class source_drv extends uvm_driver #(source_xtn);
  `uvm_component_utils(source_drv)

  source_config s_cfg;
  virtual rtr_if.SRC_DRV_MP vif;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive_task(source_xtn xtn);

endclass

function source_drv::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void source_drv::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of src drv", UVM_LOW)

  if (!uvm_config_db#(source_config)::get(this, "", "source_config", s_cfg))
    `uvm_fatal(get_type_name, "faild to get src_config in src_drv")
endfunction

function void source_drv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name, "In connect_phase of src drv", UVM_LOW)
  vif = s_cfg.vif;
endfunction

task source_drv::run_phase(uvm_phase phase);
  `uvm_info(get_type_name, "In the run phase of src drv", UVM_LOW)
  super.run_phase(phase);

  @(vif.src_drv_cb);
  vif.src_drv_cb.resetn <= 0;
  repeat (2) @(vif.src_drv_cb);
  vif.src_drv_cb.resetn <= 1;

  forever begin
    `uvm_info(get_type_name, "Get next item blocked", UVM_LOW)
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name, "Get next item unblocked", UVM_LOW)
    drive_task(req);
    seq_item_port.item_done;
    `uvm_info(get_type_name, "Acknolegdement sent", UVM_LOW)
  end
endtask

task source_drv::drive_task(source_xtn xtn);

  //@(vif.src_drv_cb);  //NOTE: is it optional? (only while using while loop both in mon and driver)

  //HINT: This delay is reqired since if no delay, the design will consider
  //the second byte of the packet, ie the payload[0] as the header.

  `uvm_info(get_type_name, "Driving the src xtn", UVM_LOW)
  `uvm_info(get_type_name, $sformatf("Xtn that is being driven in the src side is \n %s",
                                     xtn.sprint), UVM_LOW)

  wait (!vif.src_drv_cb.busy);
  vif.src_drv_cb.pkt_valid <= 1'b1;
  vif.src_drv_cb.data_in   <= xtn.header;

  @(vif.src_drv_cb);

  foreach (xtn.payload[i]) begin
    wait (!vif.src_drv_cb.busy);
    vif.src_drv_cb.data_in <= xtn.payload[i];
    @(vif.src_drv_cb);
  end

  vif.src_drv_cb.pkt_valid <= 1'b0;
  vif.src_drv_cb.data_in   <= xtn.parity;

  repeat (2) @(vif.src_drv_cb);  //NOTE: 2 cycles for asserting error due to parity mismatch

endtask





