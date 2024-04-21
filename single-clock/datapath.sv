module datapath (
  input  logic         clk, reset,
  input  logic [1:0]   PCSrc, ResultSrc,
  input  logic         ALUSrc,
  input  logic         RegWrite,
  input  logic [1:0]   ImmSrc,
  input  logic [2:0]   ALUControl,
  output logic [1:0]   Zero,
  output logic [31:0]  PC,
  input  logic [31:0]  Instr,
  output logic [31:0]  ALUResult, WriteData,
  input  logic [31:0]  ReadData,
  output logic [31:0]  Result
);

  logic [31:0] PCNext, PCPlus4, PCTarget;
  logic [31:0] ImmExt;
  logic [31:0] SrcA, SrcB;

  // Next PC reg
  flopr #(32) pcreg(.clk(clk), .reset(reset), .d(PCNext), .q(PC));
  adder pcadd4(PC, 32'd4, PCPlus4);
  adder pcaddbranch(PC, ImmExt, PCTarget);
  mux3 #(32) pcmux(PCPlus4, PCTarget, ReadData, PCSrc, PCNext);

  // Register file reg
  regfile rf(
    .clk(clk),
    .RegWrite(RegWrite),
    .ReadReg1(Instr[19:15]),
    .ReadReg2(Instr[24:20]),
    .WriteReg(Instr[11:7]),
    .WriteData(Result),
    .ReadData1(SrcA),
    .ReadData2(WriteData)
  );

  // Extend reg
  extend ext(
    .instr(Instr[31:7]),
    .immsrc(ImmSrc),
    .immext(ImmExt)
  );

  // ALU reg
  mux2 #(32) srcbmux(
    .d0(WriteData),
    .d1(ImmExt),
    .s(ALUSrc),
    .y(SrcB)
  );

  alu alu(
    .a(SrcA),
    .b(SrcB),
    .alucontrol(ALUControl),
    .result(ALUResult),
    .zero(Zero)
  );

  mux4 #(32) resultmux(
    .d0(ALUResult),
    .d1(ReadData),
    .d2(PCPlus4),
    .d3(ImmExt),
    .s(ResultSrc),
    .y(Result)
  );


endmodule
