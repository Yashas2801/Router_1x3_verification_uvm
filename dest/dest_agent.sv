class dest_agent extends uvm_agent;
  `uvm_component_utils(dest_agent)

  dest_drv drvh;
  dest_mon monh;
  dest_sequencer seqrh;
  dest_config d_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

function dest_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void dest_agent::build_phase(uvm_phase phase);

  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of dest agent", UVM_LOW)

  if (!uvm_config_db#(dest_config)::get(this, "", "dest_config", d_cfg))
    `uvm_fatal(get_type_name, "failed to get dest config in dest_agent")
  // `uvm_info(get_type_name, $sformatf("is_acive is %s", d_cfg.is_acive), UVM_LOW)

  `uvm_info(get_type_name, $sformatf("d_cfg.is_active is %s", d_cfg.is_active), UVM_LOW)
  if (d_cfg.is_active == UVM_ACTIVE) begin
    drvh  = dest_drv::type_id::create("drvh", this);
    seqrh = dest_sequencer::type_id::create("seqrh", this);
  end

  monh = dest_mon::type_id::create("monh", this);
endfunction

function void dest_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  `uvm_info(get_type_name, "In the connect phase of dst agent", UVM_LOW)

  if (d_cfg.is_active == UVM_ACTIVE) drvh.seq_item_port.connect(seqrh.seq_item_export);

endfunction
















