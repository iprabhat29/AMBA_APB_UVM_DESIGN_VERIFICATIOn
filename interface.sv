interface arb_inf;
  logic PRESET,PSEL,PENABLE,PWRITE,PREADY,PSLVERR;
  
  bit PCLK;
 
  logic [31:0] PWADDR;
  
  logic [31:0] PWDATA;
  
  logic [31:0] PRDATA;  
  
  initial forever #5 PCLK = ~ PCLK;
  
endinterface
  