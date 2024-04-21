module top(
  input logic clk, input logic reset,
  output logic [31:0] WriteData, DataAdr,
  output logic MemWrite,
  output logic [31:0] Result
);
  logic [31:0] PC, Instr, ReadData;

  // instantiate processor and memories
  imem imem_inst(.a(PC), .rd(Instr));
  riscvsingle rvsingle(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .MemWrite(MemWrite), .ALUResult(DataAdr), .WriteData(WriteData), .ReadData(ReadData), .Result(Result));
  dmem dmem_inst(.clk(clk), .we(MemWrite), .a(DataAdr), .wd(WriteData), .rd(ReadData));
endmodule
