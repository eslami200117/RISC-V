module branchdec (
  input  logic [6:0]   op,
  input  logic       Branch,
  input  logic [2:0] funct3,
  input  logic [1:0] Zero,
  input  logic       Jump,
  output logic [1:0] PCSrc
);
  logic zero;
  always@(*)
    case (funct3)
      3'b000: zero = (Zero == 2'b01); // beq
      3'b001: zero = ~Zero[0]; // bne
      3'b100: zero = (Zero == 2'b11); // blt
      3'b101: zero = (Zero == 2'b10 | Zero == 2'b01); // bge

    endcase


  assign PCSrc[0] = Branch & zero | Jump;
  assign PCSrc[1] = (op == 7'd67);
endmodule

