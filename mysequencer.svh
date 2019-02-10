class mysequencer extends uvm_sequencer #(mytransaction);
  `uvm_component_utils(mysequencer)
  uvm_blocking_put_port #(mytransaction) put_port;
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    put_port = new("put_port",this);
  endfunction
  task run_phase(uvm_phase phase);
    forever begin
      mytransaction trans_obj = new();
      trans_obj.randomize();
      `uvm_info("mysequencer","Randomized and sending to fifo",UVM_LOW)
      put_port.put(trans_obj);
      #10;
    end
  endtask
endclass