class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)

  dest_sequencer dest_seqrh[];
  source_sequencer src_seqrh[];
  env_config e_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function virtual_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg))
    `uvm_fatal(get_type_name, "failed to get env config in vseqr")
  if (e_cfg.has_dst_agent) dest_seqrh = new[e_cfg.no_of_dst_agents];

  if (e_cfg.has_src_agent) src_seqrh = new[e_cfg.no_of_src_agents];
endfunction


