class dest_agent_top extends uvm_env;
  `uvm_component_utils(dest_agent_top)

  dest_agent agth  [];
  env_config e_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function dest_agent_top::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void dest_agent_top::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of dest_agt_top", UVM_LOW)

  if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg))
    `uvm_fatal(get_type_name, "failed of get env_confign in dst_agt_top")

  `uvm_info(get_type_name, $sformatf("e_cfg.d_cfg[1].is_active is %s", e_cfg.d_cfg[1].is_active),
            UVM_LOW)
  agth = new[e_cfg.no_of_dst_agents];

  foreach (agth[i]) begin
    agth[i] = dest_agent::type_id::create($sformatf("agth[%0d]", i), this);
    uvm_config_db#(dest_config)::set(this, $sformatf("agth[%0d]*", i), "dest_config",
                                     e_cfg.d_cfg[i]);

  end
endfunction


