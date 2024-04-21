module imem_tb();
  logic [31:0] a;
  logic [31:0] rd;
  imem Imem(.a(a), .rd(rd));
  
  initial begin
    a = 0;
    repeat(10) begin
      #100 $display("Read addr %d, value %h", a, rd);
      a = a + 4;
    end
  end
endmodule


