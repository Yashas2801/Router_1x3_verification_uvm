class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  dest_config d_cfg[];
  source_config s_cfg[];
  env_config e_cfg;

  int no_of_src_agents = 1;
  int no_of_dst_agents = 3;

  bit has_src_agent = 1;
  bit has_dst_agent = 1;

  bit [1:0] addr;

  env envh;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void router_config;
endclass

function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void base_test::router_config;

  if (has_src_agent) begin
    s_cfg = new[no_of_src_agents];

    foreach (s_cfg[i]) begin
      s_cfg[i] = source_config::type_id::create($sformatf("s_cfg[%0d]", i));

      if (!uvm_config_db#(virtual rtr_if)::get(this, "", $sformatf("s_if%0d", i), s_cfg[i].vif))
        `uvm_fatal(get_type_name, "Failed to get src_vif in test")

      s_cfg[i].is_active = UVM_ACTIVE;
      e_cfg.s_cfg[i] = s_cfg[i];
    end
  end


  if (has_dst_agent) begin
    d_cfg = new[no_of_dst_agents];

    foreach (d_cfg[i]) begin
      d_cfg[i] = dest_config::type_id::create($sformatf("d_cfg[%0d]", i));

      if (!uvm_config_db#(virtual rtr_if)::get(this, "", $sformatf("d_if%0d", i), d_cfg[i].vif))
        `uvm_fatal(get_type_name, "Failed to get dest_vif in test")

      d_cfg[i].is_active = UVM_ACTIVE;
      e_cfg.d_cfg[i] = d_cfg[i];

    end
  end
endfunction

function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of Test", UVM_LOW)

  e_cfg = env_config::type_id::create("e_cfg");

  if (has_dst_agent) e_cfg.d_cfg = new[no_of_dst_agents];

  if (has_src_agent) e_cfg.s_cfg = new[no_of_src_agents];

  router_config;

  e_cfg.has_src_agent = has_src_agent;
  e_cfg.has_dst_agent = has_dst_agent;
  e_cfg.no_of_src_agents = no_of_src_agents;
  e_cfg.no_of_dst_agents = no_of_dst_agents;

  addr = $urandom % 3;

  uvm_config_db#(bit [1:0])::set(this, "*", "addr1", addr);
  //`uvm_info(get_type_name, $sformatf("d_cfg[0].is_active is %s",d_cfg[0].is_active),UVM_LOW)
  uvm_config_db#(env_config)::set(this, "*", "env_config", e_cfg);

  envh = env::type_id::create("envh", this);
endfunction


class small_test extends base_test;
  `uvm_component_utils(small_test)

  small_vseq small_vseqh;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function small_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void small_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name, "In the build phase", UVM_LOW)
endfunction

task small_test::run_phase(uvm_phase phase);
  super.run_phase(phase);

  phase.raise_objection(this);
  `uvm_info(get_type_name, "before starting the vseq", UVM_LOW)
  small_vseqh = small_vseq::type_id::create("small_vseqh");
  small_vseqh.start(envh.vseqrh);
  `uvm_info(get_type_name, "after starting the vseq", UVM_LOW)
  phase.drop_objection(this);

endtask


class medium_test extends base_test;
  `uvm_component_utils(medium_test)

  medium_vseq medium_vseqh;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function medium_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void medium_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name, "In the build phase", UVM_LOW)
endfunction

task medium_test::run_phase(uvm_phase phase);
  super.run_phase(phase);

  phase.raise_objection(this);
  `uvm_info(get_type_name, "before starting the vseq", UVM_LOW)
  medium_vseqh = medium_vseq::type_id::create("medium_vseqh");
  medium_vseqh.start(envh.vseqrh);
  `uvm_info(get_type_name, "after starting the vseq", UVM_LOW)
  phase.drop_objection(this);
endtask



class large_test extends base_test;
  `uvm_component_utils(large_test)

  large_vseq large_vseqh;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function large_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void large_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name, "In the build phase", UVM_LOW)
endfunction

task large_test::run_phase(uvm_phase phase);
  super.run_phase(phase);

  phase.raise_objection(this);
  `uvm_info(get_type_name, "before starting the vseq", UVM_LOW)
  large_vseqh = large_vseq::type_id::create("large_vseqh");
  large_vseqh.start(envh.vseqrh);
  `uvm_info(get_type_name, "after starting the vseq", UVM_LOW)
  phase.drop_objection(this);

endtask



class large_xtn_small_delay_test extends base_test;
  `uvm_component_utils(large_xtn_small_delay_test)

  large_xtn_small_delay_vseq large_xtn_small_delay_vseqh;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function large_xtn_small_delay_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void large_xtn_small_delay_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name, "In the build phase", UVM_LOW)
endfunction

task large_xtn_small_delay_test::run_phase(uvm_phase phase);
  super.run_phase(phase);

  phase.raise_objection(this);
  `uvm_info(get_type_name, "before starting the vseq", UVM_LOW)
  large_xtn_small_delay_vseqh =
      large_xtn_small_delay_vseq::type_id::create("large_xtn_small_delay_vseqh");
  large_xtn_small_delay_vseqh.start(envh.vseqrh);
  `uvm_info(get_type_name, "after starting the vseq", UVM_LOW)
  phase.drop_objection(this);

endtask

