module mux3 #(parameter WIDTH = 8) (
  input  logic [WIDTH-1:0] a, b, c,
  input  logic [1:0]       sel,
  output logic [WIDTH-1:0] y
);
  assign y = (sel == 2'b00) ? a :
             (sel == 2'b01) ? b :
             (sel == 2'b10) ? c :
             (sel == 2'b11) ? c :
             32'd0;
endmodule
