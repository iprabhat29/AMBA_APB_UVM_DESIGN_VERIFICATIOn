class myagent extends uvm_agent;
  `uvm_component_utils(myagent)
  mysequencer sq_h;
  mydriver dr_h;
  my_config config_h;
  uvm_tlm_fifo #(mytransaction) tlm_fifo;
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    sq_h = mysequencer::type_id::create("sq_h",this);
    dr_h = mydriver::type_id::create("dr_h",this);
    config_h = new();
    if (!uvm_config_db #(virtual arb_inf)::get(this, "", "dut_vi", config_h.dut_vi))  
      `uvm_fatal("FATAL MSG", "Virtual Interface Not Set Properly");
    uvm_config_db #(my_config)::set(this, "*", "config", config_h);
    tlm_fifo = new ("uvm_tlm_fifo", this, 1);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sq_h.put_port.connect(tlm_fifo.put_export);
    dr_h.get_port.connect(tlm_fifo.get_export);
  endfunction
  
  task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	#1000;
	phase.drop_objection(this);
  endtask
  
endclass