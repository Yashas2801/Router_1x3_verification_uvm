interface rtr_if (
    input bit clock
);

  //Source side + other signals
  logic resetn, pkt_valid, err, busy;
  logic [7:0] data_in;

  //Destination side signals
  logic [7:0] data_out;
  logic valid_out, read_en;

  clocking src_drv_cb @(posedge clock);
    output resetn, data_in, pkt_valid;
    input busy;
  endclocking

  clocking src_mon_cb @(posedge clock);
    input resetn, data_in, pkt_valid;
    input err, busy;
  endclocking

  clocking dst_drv_cb @(posedge clock);
    output read_en;
    input valid_out;
  endclocking

  clocking dst_mon_cb @(posedge clock);
    input read_en;
    input data_out, valid_out;
  endclocking

  modport SRC_DRV_MP(clocking src_drv_cb);
  modport SRC_MON_MP(clocking src_mon_cb);
  modport DST_DRV_MP(clocking dst_drv_cb);
  modport DST_MON_MP(clocking dst_mon_cb);
endinterface
