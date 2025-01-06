class source_config extends uvm_object;
  `uvm_object_utils(source_config)

  virtual rtr_if vif;
  uvm_active_passive_enum is_active;

  static int mon_rcvd_xtn_cnt;
  static int drv_rcvd_xtn_cnt;

  extern function new(string name = "source_config");
endclass

function source_config::new(string name = "source_config");
  super.new(name);
endfunction
