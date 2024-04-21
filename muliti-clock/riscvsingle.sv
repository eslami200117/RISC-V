module riscvsingle (
  input  logic        clk, reset,
  input  logic [31:0] ReadData,
  output logic        MemWrite,
  output logic [31:0] Adr,
  output logic [31:0] ALUResult,
  output logic [31:0] WriteData,
  output logic [31:0] Result
);

  logic                PCWrite, AdrSrc;
  logic                IRWrite, RegWrite;
  logic [1:0]          ResultSrc, ALUSrcA, ALUSrcB, Zero;
  logic [2:0]          ALUControl, ImmSrc;
  logic [31:0]         Instr;

  controller c (
    .clk            (clk),
    .reset          (reset),
    .op             (Instr[6:0]),
    .funct3         (Instr[14:12]),
    .funct7b5       (Instr[30]),
    .Zero           (Zero),
    .PCWrite        (PCWrite),
    .AdrSrc         (AdrSrc),
    .MemWrite       (MemWrite),
    .IRWrite        (IRWrite),
    .RegWrite       (RegWrite),
    .ResultSrc      (ResultSrc),
    .ALUSrcA        (ALUSrcA),
    .ALUSrcB        (ALUSrcB),
    .ImmSrc         (ImmSrc),
    .ALUControl     (ALUControl)
  );

  datapath dp (
    .clk            (clk),
    .reset          (reset),
    .PCWrite        (PCWrite),
    .AdrSrc         (AdrSrc),
    .MemWrite       (MemWrite),
    .IRWrite        (IRWrite),
    .RegWrite       (RegWrite),
    .ResultSrc      (ResultSrc),
    .ALUSrcA        (ALUSrcA),
    .ALUSrcB        (ALUSrcB),
    .ImmSrc         (ImmSrc),
    .ALUControl     (ALUControl),
    .ReadData       (ReadData),
    .Zero           (Zero),
    .Instr          (Instr),
    .WriteData      (WriteData),
    .Adr            (Adr),
    .ALUResult      (ALUResult),
    .Result         (Result)
  );
  
endmodule
