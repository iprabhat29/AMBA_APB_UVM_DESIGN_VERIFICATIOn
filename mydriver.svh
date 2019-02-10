class mydriver extends uvm_driver;
  `uvm_component_utils(mydriver)
  virtual arb_inf dut_if;
  my_config my_config_h;
  uvm_blocking_get_port #(mytransaction) get_port;
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    get_port = new("get_port",this);
    if(!uvm_config_db #(my_config)::get(this, "", "config", my_config_h))
       `uvm_fatal("FATAL MSG", "Configuration Object Not Received Properly"); 
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    dut_if = my_config_h.dut_vi;
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      mytransaction trans_obj = new();
      get_port.get(trans_obj);
      `uvm_info("mydriver","Driving the transaction",UVM_LOW)
      if(trans_obj.WRITE == 1) begin
        dut_if.PRESET<= 1;
        @(posedge dut_if.PCLK);
        dut_if.PRESET <= 0;
        dut_if.PSEL <= 1;
        dut_if.PWRITE <= trans_obj.WRITE;
        dut_if.PWADDR <= trans_obj.PWADDR;
        dut_if.PWDATA <= trans_obj.PWDATA;
        @(posedge dut_if.PCLK);
        dut_if.PENABLE <= 1;
        @(posedge dut_if.PCLK);
        dut_if.PENABLE <= 0;
        dut_if.PSEL <= 0;
        @(posedge dut_if.PCLK);
      end
      else begin
        dut_if.PRESET<= 1;
        @(posedge dut_if.PCLK);
        dut_if.PRESET <= 0;
        @(posedge dut_if.PCLK);
        dut_if.PENABLE <= 1;
        dut_if.PSEL <= 1;
        dut_if.PWADDR <= trans_obj.PWADDR;
        dut_if.PWRITE <= trans_obj.WRITE;
        @(posedge dut_if.PCLK);
        dut_if.PENABLE <= 0;
        dut_if.PSEL <= 0;
        @(posedge dut_if.PCLK);
      end
    end
  endtask
    
endclass