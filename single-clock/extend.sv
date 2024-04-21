module extend (
  input  logic [31:7] instr,
  input  logic [1:0]  immsrc,
  output logic [31:0] immext
);
  always@(*)
    case (immsrc)
      // I−type
      3'b00: immext = {{20{instr[31]}}, instr[31:20]};
      // S−type (stores)
      3'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      // B−type (branches)
      3'b10: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
      // J−type (jal)
      3'b11: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
      // U-type (lui)
      3'b11: immext = {{instr[31:12]}, 12'b000000000000};
      default: immext = 32'bx; // undefined
    endcase
endmodule
