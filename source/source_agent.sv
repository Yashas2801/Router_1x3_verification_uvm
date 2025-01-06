class source_agent extends uvm_agent;
  `uvm_component_utils(source_agent)

  source_drv drvh;
  source_mon monh;
  source_sequencer seqrh;
  source_config s_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

function source_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void source_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of source agent", UVM_LOW)

  if (!uvm_config_db#(source_config)::get(this, "", "source_config", s_cfg))
    `uvm_fatal(get_type_name, "failed to get src config in src aget")

  if (s_cfg.is_active == UVM_ACTIVE) begin
    drvh  = source_drv::type_id::create("drvh", this);
    seqrh = source_sequencer::type_id::create("seqrh", this);
  end

  monh = source_mon::type_id::create("monh", this);

endfunction

function void source_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  `uvm_info(get_type_name, "in connect phase of src agent", UVM_LOW)

  if (s_cfg.is_active == UVM_ACTIVE) drvh.seq_item_port.connect(seqrh.seq_item_export);

endfunction
