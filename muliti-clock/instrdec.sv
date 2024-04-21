module instrdec (
  input  logic [6:0] op,    
  output logic [2:0] ImmSrc     
);
  always@(*)
    case(op)
      // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
      7'b0000011: ImmSrc = 3'b000; // lw
      7'b1000011: ImmSrc = 3'b000; // jarl
      7'b0100011: ImmSrc = 3'b001; // sw
      7'b0110011: ImmSrc = 3'bxxx; // R–type
      7'b1100011: ImmSrc = 3'b010; // beq
      7'b0010011: ImmSrc = 3'b000; // I–type ALU
      7'b1101111: ImmSrc = 3'b011; // jal
      7'b0110111: ImmSrc = 3'b100; // lui
      default   : ImmSrc = 3'bxx; // ???
    endcase
endmodule