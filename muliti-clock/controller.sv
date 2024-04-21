module controller (
  input  logic        clk, reset,
  input  logic [6:0]  op,
  input  logic [2:0]  funct3,
  input  logic        funct7b5,
  input  logic [1:0]  Zero,
  output logic        PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite,
  output logic [1:0]  ResultSrc ,ALUSrcA, ALUSrcB,
  output logic [2:0]  ALUControl, ImmSrc
);
 
  logic       Branch, PCUpdate;
  logic [1:0] ALUOp;


  mainFSM MFSM(
    .clk            (clk),
    .reset          (reset),
    .op             (op), 
    .Branch         (Branch),
    .PCUpdate       (PCUpdate),
    .RegWrite       (RegWrite),
    .MemWrite       (MemWrite),
    .IRWrite        (IRWrite),
    .ResultSrc      (ResultSrc),
    .ALUSrcA        (ALUSrcA),
    .ALUSrcB        (ALUSrcB),
    .ALUOp          (ALUOp),
    .AdrSrc         (AdrSrc)
  );
  
  branchdec bd(
    .op(op), 
    .Branch(Branch), 
    .funct3(funct3), 
    .Zero(Zero), 
    .PCUpdate(PCUpdate),
    .PCWrite(PCWrite)
  );

  aludec ad(
    .opb5       (op[5]),
    .funct3     (funct3),
    .funct7b5   (funct7b5),
    .ALUOp      (ALUOp),
    .ALUControl (ALUControl)
  );

  instrdec id(
    .op         (op),
    .ImmSrc     (ImmSrc)
  );

endmodule
