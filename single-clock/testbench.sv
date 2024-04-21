`timescale 1ns/1ns
module testbench();
  logic clk = 1;
  logic reset = 1;
  logic [31:0] WriteData, DataAdr, Result;
  logic MemWrite;

  top dut(clk, reset, WriteData, DataAdr, MemWrite, Result);

  initial begin
    #50 reset = 0;
  end

  initial begin
    repeat(2000) #20 clk = ~clk;
  end


  // instantiate device to be tested



  // check results
  // always @(negedge clk) begin
  //   if (MemWrite) begin
  //     if ((DataAdr === 100) && (WriteData === 25)) begin
  //       $display("Simulation succeeded");
  //       $stop;
  //     end
  //     else if (DataAdr !== 96) begin
  //       $display("Simulation failed");
  //       $stop;
  //     end
  //   end
  // end
endmodule
