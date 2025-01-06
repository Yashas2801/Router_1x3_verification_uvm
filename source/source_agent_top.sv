class source_agent_top extends uvm_env;
  `uvm_component_utils(source_agent_top)

  source_agent agth  [];
  env_config   e_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function source_agent_top::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void source_agent_top::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build phase of source agent top", UVM_LOW)

  if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg))
    `uvm_fatal(get_type_name, "Failed to get env config in s_agent_top")

  agth = new[e_cfg.no_of_src_agents];

  foreach (agth[i]) begin
    agth[i] = source_agent::type_id::create($sformatf("agth[%0d]", i), this);
    uvm_config_db#(source_config)::set(this, $sformatf("agth[%0d]*", i), "source_config",
                                       e_cfg.s_cfg[i]);
  end
endfunction
