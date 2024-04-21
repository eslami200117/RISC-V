module riscvsingle_tb();

  // Declare signals
  logic clk;
  logic reset;
  logic [31:0] PC;
  logic [31:0] Instr;
  logic MemWrite;
  logic [31:0] ALUResult;
  logic [31:0] WriteData;
  logic [31:0] ReadData;

  // Instantiate the module
  riscvsingle dut(
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .Instr(Instr),
    .MemWrite(MemWrite),
    .ALUResult(ALUResult),
    .WriteData(WriteData),
    .ReadData(ReadData)
  );

  // Initialize inputs
  initial begin
    clk = 0;
    reset = 1;
    Instr = 32'h00000000;
    #10;
    reset = 0;
    Instr = 32'h00200093; // addi x1, x0, 2
    #10;
    Instr = 32'h00208093; // addi x2, x0, 2
    #10;
    Instr = 32'h00208033; // add x3, x1, x2
    #10;
    Instr = 32'h00008083; // ld x4, 0(x1)
    #10;
    Instr = 32'hffdff06f; // jal x1, -8
    #10;
    Instr = 32'h0000006f; // j 0
    #300;
    $stop; 
  end

  // Generate clock signal
  always #3 clk <= ~clk;

endmodule
