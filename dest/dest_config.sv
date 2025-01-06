class dest_config extends uvm_object;
  `uvm_object_utils(dest_config)

  virtual rtr_if vif;
  uvm_active_passive_enum is_active;

  static int mon_rcvd_xtn_cnt;
  static int drv_rcvd_xtn_cnt;

  extern function new(string name = "dest_config");
endclass

function dest_config::new(string name = "dest_config");
  super.new(name);
endfunction
