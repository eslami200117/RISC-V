module datapath (
  input  logic         clk, reset,
  input  logic         PCWrite, AdrSrc,
  input  logic         MemWrite, IRWrite, RegWrite,
  input  logic [1:0]   ResultSrc, ALUSrcA, ALUSrcB,
  input  logic [2:0]   ALUControl, ImmSrc,
  input  logic [31:0]  ReadData,
  output logic [1:0]   Zero,
  output logic [31:0]  Instr,
  output logic [31:0]  WriteData, Adr,
  output logic [31:0]  ALUResult, Result
);

  logic [31:0] PC, OldPC;
  logic [31:0] ALUOut, Data, A;
  logic [31:0] ImmExt;
  logic [31:0] SrcA, SrcB, RD1, RD2;



  reg1 #(32) PCNextReg(.clk(clk), .reset(reset), .en(PCWrite), .d(Result), .q(PC));
  reg1 #(32) RDReg(.clk(clk), .reset(reset), .en(1'b1), .d(ReadData), .q(Data));
  reg1 #(32) ALUResultReg(.clk(clk), .reset(reset), .en(1'b1), .d(ALUResult), .q(ALUOut));
  reg2 #(32) IRReg(.clk(clk), .reset(reset), .en(IRWrite), .d0(PC), .d1(ReadData), .q0(OldPC), .q1(Instr));
  reg2 #(32) RFreg(.clk(clk), .reset(reset), .en(1'b1), .d0(RD1), .d1(RD2), .q0(A), .q1(WriteData));

  mux2 #(32) AdrSelect(.d0(PC), .d1(Result), .s(AdrSrc), .y(Adr));
  mux3 #(32) ALUSrsASelect(.d0(PC), .d1(OldPC), .d2(A), .s(ALUSrcA), .y(SrcA));
  mux3 #(32) ALUSrsBSelect(.d0(WriteData), .d1(ImmExt), .d2(32'd4), .s(ALUSrcB), .y(SrcB));
  mux4 #(32) ResultSrcSelect(.d0(ALUOut), .d1(Data), .d2(ALUResult), .d3(ImmExt), .s(ResultSrc), .y(Result));

  // Register file reg
  regfile rf(
    .clk(clk),
    .RegWrite(RegWrite),
    .ReadReg1(Instr[19:15]),
    .ReadReg2(Instr[24:20]),
    .WriteReg(Instr[11:7]),
    .WriteData(Result),
    .ReadData1(RD1),
    .ReadData2(RD2)
  );

  // Extend reg
  extend ext(
    .instr(Instr[31:7]),
    .immsrc(ImmSrc),
    .immext(ImmExt)
  );

  // ALU reg
  alu alu(
    .a(SrcA),
    .b(SrcB),
    .alucontrol(ALUControl),
    .result(ALUResult),
    .zero(Zero)
  );
endmodule
