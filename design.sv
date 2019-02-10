module dut_interface(arb_inf a);
  abp_sram inst(a.PCLK,a.PRESET,a.PSEL,a.PENABLE,a.PWRITE,a.PWADDR,a.PWDATA,a.PRDATA,a.PREADY,a.PSLVERR);

endmodule

module abp_sram 
  	#(parameter ADDR_BUS_WIDTH = 32,
      parameter DATA_BUS_WIDTH = 32,
      parameter DATA_BLOCK = 8,
      parameter MEMWIDTH = 32,
      parameter RESET = 0)
  (
    input PCLK,
    input PRESET,
    input PSEL,
    input PENABLE,  
    input PWRITE,
    input [ADDR_BUS_WIDTH-1:0] PWADDR,
    input [DATA_BUS_WIDTH-1:0] PWDATA,
    output logic [DATA_BUS_WIDTH-1:0] PRDATA,
    output logic PREADY,
    output logic PSLVERR
  );
  
  
  localparam IDLE   = 0;
  localparam SETUP  = 1;
  localparam ACCESS = 2;
  localparam READ = 0;
  localparam WRITE = 1;
  
  reg [DATA_BLOCK-1:0] memory [0:DATA_BUS_WIDTH-1];
  
  task reset_mem;
    for(int i = 0;i<DATA_BUS_WIDTH;i++) begin
      memory[i] = i;
    end
  endtask
  
  
  always @(posedge PCLK or posedge PRESET) begin
    if (PRESET) begin
      PRDATA <= 0;
      PREADY <= 0;
      PSLVERR <= 0;
      reset_mem();
    end
    else begin
      if(PWRITE == READ) begin
        if(PENABLE == 1 && PSEL == 1) begin
          if(PWADDR < MEMWIDTH) begin
            PREADY <= 1;
            PRDATA <= memory[PWADDR];
            PSLVERR <= 0;
          end
          else PSLVERR <= 1;
        end
        else PREADY <= 0;
      end
      else begin
        if(PSEL) begin
          if(PENABLE) begin
            PREADY <= 1;
            if(PWADDR < MEMWIDTH) begin
              memory[PWADDR] <= PWDATA;
              PREADY <= 1;
              PSLVERR <= 0;
            end
            else
              PSLVERR <= 1;
          end
          else begin
            PREADY <= 0;
          end
        end
        else begin
          PREADY <= 0;
        end
      end
    end
  end
endmodule  			