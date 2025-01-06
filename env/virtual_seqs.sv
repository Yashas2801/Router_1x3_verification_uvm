class virtual_seqs_base extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(virtual_seqs_base)

  //NOTE: Inside vseq(local v seqr and seqr handels to start the seq on)
  virtual_sequencer vseqrh;
  source_sequencer src_seqrh[];
  dest_sequencer dst_seqrh[];

  //NOTE: These are the source side sequences
  small_xtn small_xtnh;
  medium_xtn medium_xtnh;
  large_xtn large_xtnh;

  //NOTE: These are the destination side sequences
  small_delay small_delayh;
  medium_delay medium_delayh;
  large_delay large_delayh;


  env_config e_cfg;
  bit [1:0] addr;

  extern function new(string name = "virtual_seqs_base");
  extern task body;
endclass

function virtual_seqs_base::new(string name = "virtual_seqs_base");
  super.new(name);
endfunction

task virtual_seqs_base::body;

  if (!uvm_config_db#(bit [1:0])::get(null, get_full_name(), "addr1", addr))
    `uvm_fatal(get_type_name, "failed to get addr in vseqs")

  if (!uvm_config_db#(env_config)::get(null, get_full_name(), "env_config", e_cfg))
    `uvm_fatal(get_type_name, "failed to get env config in v seqs")

  //  `uvm_info(get_type_name, $sformatf("dest addr = %b", addr), UVM_LOW)

  if (e_cfg.has_dst_agent) dst_seqrh = new[e_cfg.no_of_dst_agents];

  if (e_cfg.has_src_agent) src_seqrh = new[e_cfg.no_of_src_agents];


  //NOTE: Local vseqrh is pointing to m_seqr , m_seqr will point to the seqr the vseq will start on(ie vseqr in the env)
  assert ($cast(vseqrh, m_sequencer))
  else `uvm_error(get_type_name, "failed to to $cast in vseqs")

  //WARN: Here order matters (got an error bad handle refrence ),I put the $cast at last

  foreach (dst_seqrh[i]) dst_seqrh[i] = vseqrh.dest_seqrh[i];

  foreach (src_seqrh[i]) src_seqrh[i] = vseqrh.src_seqrh[i];


endtask


class small_vseq extends virtual_seqs_base;
  `uvm_object_utils(small_vseq)

  extern function new(string name = "small_vseq");
  extern task body;
endclass


function small_vseq::new(string name = "small_vseq");
  super.new(name);
endfunction


task small_vseq::body;
  super.body;
  small_xtnh   = small_xtn::type_id::create("small_xtnh");
  small_delayh = small_delay::type_id::create("small_delayh");
  fork
    small_xtnh.start(src_seqrh[0]);
    small_delayh.start(dst_seqrh[addr]);
  join
endtask



class medium_vseq extends virtual_seqs_base;
  `uvm_object_utils(medium_vseq)

  extern function new(string name = "medium_vseq");
  extern task body;
endclass


function medium_vseq::new(string name = "medium_vseq");
  super.new(name);
endfunction


task medium_vseq::body;
  super.body;
  medium_xtnh   = medium_xtn::type_id::create("medium_xtnh");
  medium_delayh = medium_delay::type_id::create("medium_delayh");
  fork
    medium_xtnh.start(src_seqrh[0]);
    medium_delayh.start(dst_seqrh[addr]);
  join
endtask



class large_vseq extends virtual_seqs_base;
  `uvm_object_utils(large_vseq)

  extern function new(string name = "large_vseq");
  extern task body;
endclass


function large_vseq::new(string name = "large_vseq");
  super.new(name);
endfunction


task large_vseq::body;
  super.body;
  large_xtnh   = large_xtn::type_id::create("large_xtnh");
  large_delayh = large_delay::type_id::create("large_delayh");
  fork
    large_xtnh.start(src_seqrh[0]);
    large_delayh.start(dst_seqrh[addr]);
  join
endtask



class large_xtn_small_delay_vseq extends virtual_seqs_base;
  `uvm_object_utils(large_xtn_small_delay_vseq)

  extern function new(string name = "large_xtn_small_delay_vseq");
  extern task body;
endclass


function large_xtn_small_delay_vseq::new(string name = "large_xtn_small_delay_vseq");
  super.new(name);
endfunction


task large_xtn_small_delay_vseq::body;
  super.body;
  large_xtnh   = large_xtn::type_id::create("large_xtnh");
  small_delayh = small_delay::type_id::create("small_delayh");
  fork
    large_xtnh.start(src_seqrh[0]);
    small_delayh.start(dst_seqrh[addr]);
  join
endtask













