class env extends uvm_env;
  `uvm_component_utils(env)

  source_agent_top sagt_top;
  dest_agent_top dagt_top;
  scoreboard sb;
  virtual_sequencer vseqrh;
  env_config e_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

function env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void env::build_phase(uvm_phase phase);
  if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg))
    `uvm_fatal(get_type_name, "Failed to get env config in env")

  if (e_cfg.has_src_agent) sagt_top = source_agent_top::type_id::create("sagt_top", this);
  if (e_cfg.has_dst_agent) dagt_top = dest_agent_top::type_id::create("dagt_top", this);

  sb = scoreboard::type_id::create("sb", this);

  vseqrh = virtual_sequencer::type_id::create("vseqrh", this);
endfunction

function void env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  for (int i = 0; i < e_cfg.no_of_src_agents; i++) begin
    vseqrh.src_seqrh[i] = sagt_top.agth[i].seqrh;
  end
  for (int i = 0; i < e_cfg.no_of_dst_agents; i++) begin
    vseqrh.dest_seqrh[i] = dagt_top.agth[i].seqrh;
  end

  foreach (e_cfg.s_cfg[i]) begin
    sagt_top.agth[i].monh.ana_port.connect(sb.source_fifo[i].analysis_export);
  end

  foreach (e_cfg.d_cfg[i]) begin
    dagt_top.agth[i].monh.ana_port.connect(sb.dest_fifo[i].analysis_export);
  end
endfunction

function void env::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction
