module alu(
  input [31:0] a, b,
  input [2:0] alucontrol,
  output logic [31:0] result,
  output logic [1:0] zero
);
  wire [31:0] condinvb, sum;
  wire v;                // overflow
  wire isAddSub;         // true when it is an add or subtract operation
  
  // Compute the inverse of b if alucontrol[0] is 1, otherwise use b as is
  assign condinvb = alucontrol[0] ? ~b : b;
  
  // Compute the sum of a, condinvb, and the carry-in alucontrol[0]
  assign sum = a + condinvb + alucontrol[0];
  
  // Determine if the operation is an add or subtract
  assign isAddSub = ~alucontrol[2] & ~alucontrol[1] | ~alucontrol[1] & alucontrol[0];
  
  // Calculate the result based on the alucontrol input
  always @*
    case (alucontrol)
      3'b000: result = sum;             // add
      3'b001: result = a - condinvb - alucontrol[0]; // subtract
      3'b010: result = a & b;           // and
      3'b011: result = a | b;           // or
      3'b100: result = a ^ b;           // xor
      3'b101: result = (a < b) ? 1 : 0; // slt
      3'b110: result = a << b[4:0];     // sll
      3'b111: result = a >> b[4:0];     // srl
      default: result = 32'bx;          // unknown operation
    endcase
    
  // Determine if the result is zero
  assign zero[0] = (result == 32'b0);
  assign zero[1] = result[31];

  
  // Determine if there is an overflow
  assign v = ~(alucontrol[0] ^ a[31] ^ b[31]) & (a[31] ^ result[31]) & isAddSub;
  
endmodule
