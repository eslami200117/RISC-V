module regfile(
  input logic clk,
  input logic RegWrite,
  input logic [4:0] ReadReg1, ReadReg2, WriteReg,
  input logic [31:0] WriteData,
  output logic [31:0] ReadData1, ReadData2
);
  logic [31:0] rf[31:0];   // 32 registers


initial begin
  // Initialize all registers to zero
  for (int i = 0; i < 32; i++) begin
    rf[i] = 0;
  end
end


  // Three-ported register file
  // Read two ports combinationaly (ReadReg1/ReadData1, ReadReg2/ReadData2)
  // Write third port on the rising edge of the clock (WriteReg/WriteReg/RegWrite)
  // Register 0 hardwired to 0
  always @(posedge clk) begin
    if (RegWrite) rf[WriteReg] <= WriteData;
  end
  
  // Read data from the register file
  assign ReadData1 = (ReadReg1 != 6'd0) ? rf[ReadReg1] : 32'd0;
  assign ReadData2 = (ReadReg2 != 6'd0) ? rf[ReadReg2] : 32'd0;

endmodule
