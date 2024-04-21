module dmem_tb();

  // Inputs
  logic clk;
  logic we;
  logic [31:0] a;
  logic [31:0] wd;

  // Outputs
  logic [31:0] rd;

  // Instantiate the Unit Under Test (UUT)
  dmem uut (
    .clk(clk), 
    .we(we), 
    .a(a), 
    .wd(wd), 
    .rd(rd)
  );

  initial begin
    // Initialize Inputs
    clk = 0;
    we = 0;
    a = 5;
    wd = 0;

    // Wait 10 clock cycles for initialization
    #53;
    a = 10;
    #83;

    // Test write operation
    we = 1;
    a = 5; // Address 63
    wd = 32'hA5A5A5A5;
    #92;
    we = 0; // Stop writing

    // Test read operation
    a = 5; // Address 60
    #94;
    a = 0;
    repeat(64) begin
      #100 $display("Read addr %d, value %h", a, rd);
      a = a + 1;
    end

  end

  always #5 clk = ~clk;

endmodule
