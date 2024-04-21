`timescale 1ns/1ns
module testbench();
  logic clk = 1;
  logic reset = 1;
  logic [31:0] WriteData, DataAdr, Result;
  

  top dut(clk, reset, WriteData, DataAdr, Result);

  initial begin
    #50 reset = 0;
  end

  initial begin
    repeat(2000) #20 clk = ~clk;
  end

endmodule
