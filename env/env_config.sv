class env_config extends uvm_object;
  `uvm_object_utils(env_config)

  source_config s_cfg[];
  dest_config d_cfg[];

  int no_of_src_agents;
  int no_of_dst_agents;
  bit has_src_agent;
  bit has_dst_agent;

  extern function new(string name = "env_config");
endclass

function env_config::new(string name = "env_config");
  super.new(name);
endfunction

