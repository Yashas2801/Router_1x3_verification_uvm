class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(source_xtn) source_fifo[];
  uvm_tlm_analysis_fifo #(dest_xtn) dest_fifo[];

  source_xtn source_data;
  dest_xtn dest_data;

  source_xtn src_cov;
  dest_xtn dst_cov;

  env_config e_cfg;

  covergroup src_cg;
    ADDR: coverpoint src_cov.header[1:0] {
      bins dest1 = {2'b00}; bins dest2 = {2'b01}; bins dest3 = {2'b10};
    }

    LENGTH: coverpoint src_cov.header[7:2] {
      bins small_packet = {[1 : 14]};
      bins medium_packet = {[15 : 40]};
      bins large_packet = {[41 : 63]};
    }

    ERROR: coverpoint src_cov.err {bins err_yes = {1}; bins err_no = {0};}

  endgroup

  covergroup dst_cg;
    ADDR: coverpoint dst_cov.header[1:0] {
      bins dest1 = {2'b00}; bins dest2 = {2'b01}; bins dest3 = {2'b10};
    }

    LENGTH: coverpoint dst_cov.header[7:2] {
      bins small_packet = {[1 : 14]};
      bins medium_packet = {[15 : 40]};
      bins large_packet = {[41 : 63]};
    }

  endgroup


  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task compare(source_xtn src_xtn, dest_xtn dst_xtn);
endclass

function scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
  src_cg = new;
  dst_cg = new;
endfunction

function void scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_type_name, "In the build_phase of sb", UVM_LOW)

  if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg))
    `uvm_fatal(get_type_name, "failed to get env_config in the sb")

  source_fifo = new[e_cfg.no_of_src_agents];
  dest_fifo   = new[e_cfg.no_of_dst_agents];

  foreach (source_fifo[i]) begin
    source_fifo[i] = new($sformatf("source_fifo[%0d]", i), this);
  end
  foreach (dest_fifo[i]) begin
    dest_fifo[i] = new($sformatf("dest_fifo[%0d]", i), this);
  end
endfunction


task scoreboard::run_phase(uvm_phase phase);
  super.run_phase(phase);

  `uvm_info(get_type_name, "In the run_phase of sb", UVM_LOW)

  forever begin
    fork
      //NOTE: source_side begin_end
      begin
        source_fifo[0].get(source_data);
        source_data.print;
        src_cov = source_data;
        src_cg.sample;
      end

      //NOTE: dest_side begin_end
      begin
        fork
          begin
            dest_fifo[0].get(dest_data);
            dest_data.print;
            dst_cov = dest_data;
            dst_cg.sample;
          end

          begin
            dest_fifo[1].get(dest_data);
            dest_data.print;
            dst_cov = dest_data;
            dst_cg.sample;
          end

          begin
            dest_fifo[2].get(dest_data);
            dest_data.print;
            dst_cov = dest_data;
            dst_cg.sample;
          end
        join_any
        disable fork;
      end
    join
    compare(source_data, dest_data);
  end


endtask

task scoreboard::compare(source_xtn src_xtn, dest_xtn dst_xtn);
  if (src_xtn.header == dst_xtn.header) begin
    `uvm_info(get_type_name, "header matched", UVM_LOW)
  end else begin
    `uvm_error(get_type_name, "header mismatched")
  end
  if (src_xtn.payload == dst_xtn.payload) begin
    `uvm_info(get_type_name, "payload matched", UVM_LOW)
  end else begin
    `uvm_error(get_type_name, "payload mismatched")
  end
  if (src_xtn.parity == dst_xtn.parity) begin
    `uvm_info(get_type_name, "parity matched", UVM_LOW)
  end else begin
    `uvm_error(get_type_name, "parity mismatched")
  end

endtask




















