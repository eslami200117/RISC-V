module top(
  input logic clk, input logic reset,
  output logic [31:0] WriteData, DataAdr,
  output logic [31:0] Result
);
  logic MemWrite;
  logic [31:0] Adr, ReadData, ALUResult;

  // instantiate processor and memories
  riscvsingle rvsingle(.clk(clk), .reset(reset), .ReadData(ReadData), .MemWrite(MemWrite), .Adr(Adr), .ALUResult(ALUResult), .WriteData(WriteData), .Result(Result));
  dmem dmem_inst(.clk(clk), .we(MemWrite), .a(Adr), .wd(WriteData), .rd(ReadData));
endmodule
