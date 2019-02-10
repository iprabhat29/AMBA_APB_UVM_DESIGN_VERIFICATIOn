// Code your testbench here
// or browse Examples
/*module tb;
  logic RESET,SEL,ENABLE,WRITE,READY,SLVERR;
  
  bit CLK;
 
  logic [31:0] PWADDR;
  
  logic [31:0] PWDATA;
  
  logic [31:0] PRDATA;
  
  abp_sram inst(CLK,RESET,SEL,ENABLE,WRITE,PWADDR,PWDATA,PRDATA,PREADY,PSLVERR);
  
  int adr = 10;
  
  initial repeat(100) #4 CLK = ~ CLK;
  
  initial begin
    @(posedge CLK);
    RESET <= 1;
    @(posedge CLK);
    RESET <= 0;
    @(posedge CLK);
    ENABLE <= 1;
    SEL <= 1;
    PWADDR <= 10; 
    WRITE <= 0;
    @(posedge CLK);
    ENABLE <= 0;
    SEL <= 0;
    @(posedge CLK);
    SEL <= 1;
    WRITE <= 1;
    PWADDR <= 100;
    PWDATA <= 100;
    @(posedge CLK);
    ENABLE <= 1;
    @(posedge CLK);
	ENABLE <= 0;
    @(posedge CLK);
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule*/
`include "mypackage.svh"
`include "uvm_macros.svh"
`include "interface.sv"
module tb;
  import uvm_pkg::*;
  import mypackage::*;
  arb_inf a();
  dut_interface inst0(a);
  initial begin
    uvm_config_db #(virtual arb_inf)::set(null,"*", "dut_vi", a);
    run_test("myagent");
  end
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  initial #1000 $finish;
endmodule


