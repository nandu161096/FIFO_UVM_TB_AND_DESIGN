`include "uvm_macros.svh"
import uvm_pkg::*;

`uvm_analysis_imp_decl(_exp)
`uvm_analysis_imp_decl(_act)

class fifo_config extends uvm_object;
  `uvm_object_utils(fifo_config)
  
  function new(string path="fifo_config");
    super.new(path);
  endfunction
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
endclass

class transaction extends uvm_sequence_item;
   `uvm_object_utils(transaction)
  rand bit [7:0] din;
  bit [7:0] dout;
  
  function new(string path="transaction");
    super.new(path);
  endfunction
  
endclass

class rand_data_wr extends uvm_sequence#(transaction);
   `uvm_object_utils(rand_data_wr)
  transaction tr;
  
  function new(string path="rand_data_wr");
    super.new(path);
  endfunction
  
  virtual task body();
    repeat(10) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      finish_item(tr);
    end
  endtask
endclass

class sco extends uvm_scoreboard;
  `uvm_component_utils(sco)
   uvm_analysis_imp_exp#(transaction, sco) recv_exp;
   uvm_analysis_imp_act#(transaction, sco) recv_act;
   bit [7:0] last_din;
  
  function new (input string path = "sco", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
   super.build_phase(phase);
    recv_exp = new("recv_exp", this);
    recv_act = new("recv_act", this);
  endfunction
  
  virtual function void write_act(transaction tr);
    `uvm_info("SCO", $sformatf("Act din %0d dout %0d",tr.din,tr.dout), UVM_NONE);
    if (last_din == tr.din) begin
      `uvm_info("SCO", $sformatf("Test passed din %0d dout %0d",tr.din,tr.dout), UVM_NONE);
    end
    else begin
      `uvm_info("SCO", $sformatf("Test failed din %0d dout %0d",tr.din,tr.dout), UVM_NONE);
    end
  endfunction 
 
  virtual function void write_exp(transaction tr);
    `uvm_info("SCO", $sformatf("Exp din %0d dout %0d",tr.din,tr.dout), UVM_NONE);
    last_din = tr.din;
  endfunction
endclass

class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
   virtual fifo_interface finf;
   transaction tr;
   uvm_analysis_port#(transaction) send_drv;
  
    function new (input string path = "driver", uvm_component parent = null);
    super.new(path,parent);
    send_drv = new("send_drv", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    if (!uvm_config_db#(virtual fifo_interface)::get(null, "", "finf", finf))
      `uvm_error("drv","Unable to access Interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    #20;
    forever begin
      seq_item_port.get_next_item(tr);
      @(posedge finf.clk); 
      finf.rst <= 1'b0;
      finf.wr <= 1'b1;
      finf.din <= tr.din;
      @(posedge finf.clk); 
      `uvm_info("DRV", $sformatf("mode : Write din:%0d", finf.din), UVM_NONE); 
      finf.wr <= 1'b0;
      send_drv.write(tr);
      seq_item_port.item_done();
    end
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
   virtual fifo_interface finf;
   transaction tr;
   uvm_analysis_port#(transaction) send_mon;
  
   function new (input string path = "monitor", uvm_component parent = null);
    super.new(path,parent);
    send_mon = new("send_mon", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    if (!uvm_config_db#(virtual fifo_interface)::get(null, "", "finf", finf))
      `uvm_error("mon","Unable to access Interface");
  endfunction  
  
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge finf.clk); 
      tr.din <= finf.din;
      tr.dout <= finf.dout;
      if ((tr.din !=0)) begin
      `uvm_info("MON", $sformatf("mode : Write din:%0d dout %0d", finf.din, finf.dout), UVM_NONE);
      send_mon.write(tr);
      end
    end
    endtask 
  
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
   monitor mon;
   driver drv;
   uvm_sequencer #(transaction)seqr;
  
   function new (input string path = "agent", uvm_component parent = null);
    super.new(path,parent);
   endfunction
  
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon =  monitor::type_id::create("mon",this);
      drv =  driver::type_id::create("drv",this);
      seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
    endfunction
  
    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
   agent a;
   sco s;
  
   function new (input string path = "env", uvm_component parent = null);
    super.new(path,parent);
  endfunction  
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      a =  agent::type_id::create("a",this);
      s =  sco::type_id::create("s",this);
    endfunction
  
    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      a.mon.send_mon.connect(s.recv_act);
      a.drv.send_drv.connect(s.recv_exp);
    endfunction
endclass

class fifo_test extends uvm_test;
   `uvm_component_utils(fifo_test)
   env e;
   rand_data_wr rand_seqr;
  
   function new (input string path = "fifo_test", uvm_component parent = null);
    super.new(path,parent);
  endfunction  
  
  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     e =  env::type_id::create("e",this);
     rand_seqr = rand_data_wr::type_id::create("rand_seqr");
  endfunction
  
  task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST","invoking seq",UVM_LOW);
      rand_seqr.start(e.a.seqr);
      #1000;
      phase.drop_objection(this);
  endtask
endclass

module tb_top();
  fifo_interface finf();
  
  fifo_dut fifo (.clk(finf.clk),.rst(finf.rst), .wr(finf.wr),.rd(finf.rd), .din(finf.din), .dout(finf.dout), .full(finf.full), .empty(finf.empty));
  
  initial begin
    finf.rst = 1;
    #20;
    finf.rst = 0;
    finf.clk = 0;
  end
  
  always #10 finf.clk = ~finf.clk;
  
  initial begin 
    uvm_config_db#(virtual fifo_interface)::set(null, "*", "finf", finf);
    run_test("fifo_test");
  end 

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
