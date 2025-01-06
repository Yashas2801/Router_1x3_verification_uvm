class dest_drv extends uvm_driver #(dest_xtn);
  `uvm_component_utils(dest_drv)

  virtual rtr_if.DST_DRV_MP vif;
  dest_config d_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive_task(dest_xtn xtn);
endclass

function dest_drv::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void dest_drv::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of dest driver", UVM_LOW)

  if (!uvm_config_db#(dest_config)::get(this, "", "dest_config", d_cfg))
    `uvm_fatal(get_type_name, "failed to get dest_config if dest_drv")

endfunction

function void dest_drv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  `uvm_info(get_type_name, "In the connect phase of dest_drv", UVM_LOW)

  vif = d_cfg.vif;

endfunction


task dest_drv::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name, "In the run phase of dest driver", UVM_LOW)
  forever begin
    `uvm_info(get_type_name, "get_next_item asserted", UVM_LOW)
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name, "get_next_item unblocked", UVM_LOW)
    drive_task(req);
    seq_item_port.item_done;
    `uvm_info(get_type_name, "acknoledgement sent from driver", UVM_LOW)
  end
endtask

task dest_drv::drive_task(dest_xtn xtn);
  `uvm_info(get_type_name, "this is the drive task", UVM_LOW)
  `uvm_info(get_type_name, $sformatf("This is the dest trans,\n %s", xtn.sprint()), UVM_LOW)

  @(vif.dst_drv_cb);
  `uvm_info(get_type_name, "A delay before waiting for valid out", UVM_LOW)

  wait (vif.dst_drv_cb.valid_out);
  `uvm_info(get_type_name, "Captured valid out", UVM_LOW)

  repeat (xtn.delay) @(vif.dst_drv_cb);

  `uvm_info(get_type_name, "before asserting rd_enb", UVM_LOW)
  vif.dst_drv_cb.read_en <= 1'b1;
  `uvm_info(get_type_name, "after asserting rd_enb", UVM_LOW)

  wait (~vif.dst_drv_cb.valid_out);

  vif.dst_drv_cb.read_en <= 1'b0;

  @(vif.dst_drv_cb);

endtask










