class mytransaction extends uvm_sequence_item;
  
  logic RESET,SEL,ENABLE;
  rand logic WRITE;
   
  rand logic [31:0] PWADDR;
  
  rand logic [31:0] PWDATA;
  
  constraint addr_range { PWADDR inside {[0:31]}; }  
  task reset_sys;
    this.RESET = 1;
    this.SEL = 0;
    this.ENABLE = 0;
    this.PWDATA = 0;
    this.PWADDR = 0;
  endtask
  
  task read_data;
    this.RESET <= 0;
    this.SEL <= 1;
    this.ENABLE <= 1;
    this.WRITE <= 0;
  endtask
  
endclass