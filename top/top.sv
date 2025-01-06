module top;

  import router_pkg::*;
  import uvm_pkg::*;

  bit clock;

  always #5 clock = ~clock;

  rtr_if s_if0 (clock);
  rtr_if d_if0 (clock);
  rtr_if d_if1 (clock);
  rtr_if d_if2 (clock);

  router_top duv (

      .clk(clock),
      .resetn(s_if0.resetn),

      // Connected to the source interface
      .pkt_valid(s_if0.pkt_valid),
      .data_in(s_if0.data_in),
      .err(s_if0.err),
      .busy(s_if0.busy),

      // Connected to the destination interface 0
      .read_en_0  (d_if0.read_en),
      .valid_out_0(d_if0.valid_out),
      .data_out_0 (d_if0.data_out),

      // Connected to the destination interface 1
      .read_en_1  (d_if1.read_en),
      .valid_out_1(d_if1.valid_out),
      .data_out_1 (d_if1.data_out),

      // Connected to the destination interface 2
      .read_en_2  (d_if2.read_en),
      .valid_out_2(d_if2.valid_out),
      .data_out_2 (d_if2.data_out)

  );

  initial begin

    uvm_config_db#(virtual rtr_if)::set(null, "*", "s_if0", s_if0);

    uvm_config_db#(virtual rtr_if)::set(null, "*", "d_if0", d_if0);
    uvm_config_db#(virtual rtr_if)::set(null, "*", "d_if1", d_if1);
    uvm_config_db#(virtual rtr_if)::set(null, "*", "d_if2", d_if2);
    run_test();  // NOTE: +UVM_TESTNAME="test class name"

  end

  property stable_data;
    @(posedge clock) s_if0.busy |=> $stable(
        s_if0.data_in
    );
  endproperty : stable_data

  property busy_check;
    @(posedge clock) $rose(
        s_if0.pkt_valid
    ) |=> s_if0.busy;
  endproperty : busy_check

  property valid_signal;
    @(posedge clock) $rose(
        s_if0.pkt_valid
    ) |-> ##3 (d_if0.valid_out | d_if1.valid_out | d_if2.valid_out);
  endproperty : valid_signal

  property rd_en0;
    @(posedge clock) d_if0.valid_out |-> ##[1:29] d_if0.read_en;
  endproperty : rd_en0

  property rd_en1;
    @(posedge clock) d_if1.valid_out |-> ##[1:29] d_if1.read_en;
  endproperty : rd_en1

  property rd_en2;
    @(posedge clock) d_if2.valid_out |-> ##[1:29] d_if2.read_en;
  endproperty : rd_en2

  property read_en_low0;
    @(posedge clock) $fell(
        d_if0.valid_out
    ) |=> $fell(
        d_if0.read_en
    );
  endproperty : read_en_low0

  property read_en_low1;
    @(posedge clock) $fell(
        d_if1.valid_out
    ) |=> $fell(
        d_if1.read_en
    );
  endproperty : read_en_low1

  property read_en_low2;
    @(posedge clock) $fell(
        d_if2.valid_out
    ) |=> $fell(
        d_if2.read_en
    );
  endproperty : read_en_low2

  SD :
  assert property (stable_data) begin
    $display("stable_data assertion pass");
  end else begin
    $display("stableSD_data assertion fail");
  end

  BC :
  assert property (busy_check) begin
    $display("busy_check assertion pass");
  end else begin
    $display("busy_check assertion fail");
  end

  VS :
  assert property (valid_signal) begin
    $display("valid_signal assertion pass");
  end else begin
    $display("valid_signal assertion fail");
  end

  RE0 :
  assert property (rd_en0) begin
    $display("rd_en0 assertion pass");
  end else begin
    $display("rd_en0 assertion fail");
  end

  RE1 :
  assert property (rd_en1) begin
    $display("rd_en1 assertion pass");
  end else begin
    $display("rd_en1 assertion fail");
  end

  RE2 :
  assert property (rd_en2) begin
    $display("rd_en2 assertion pass");
  end else begin
    $display("rd_en2 assertion fail");
  end

  REL0 :
  assert property (read_en_low0) begin
    $display("read_en_low0 assertion pass");
  end else begin
    $display("read_en_low0 assertion fail");
  end

  REL1 :
  assert property (read_en_low1) begin
    $display("read_en_low1 assertion pass");
  end else begin
    $display("read_en_low1 assertion fail");
  end

  REL2 :
  assert property (read_en_low2) begin
    $display("read_en_low2 assertion pass");
  end else begin
    $display("read_en_low2 assertion fail");
  end

  C1 :
  cover property (stable_data);
  C2 :
  cover property (busy_check);
  C3 :
  cover property (valid_signal);
  C4 :
  cover property (rd_en0);
  C5 :
  cover property (rd_en1);
  C6 :
  cover property (rd_en2);
  C7 :
  cover property (read_en_low0);
  C8 :
  cover property (read_en_low1);
  C9 :
  cover property (read_en_low2);

endmodule
