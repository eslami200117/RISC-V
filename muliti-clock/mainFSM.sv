module mainFSM (
  input  logic        clk, reset,
  input  logic [6:0]  op,
  output logic        Branch, PCUpdate, RegWrite, MemWrite, IRWrite,
  output logic [1:0]  ResultSrc, ALUSrcA, ALUSrcB, ALUOp,
  output logic        AdrSrc
);

  logic [3:0] ns, ps;
  logic [3:0] Fetch = 0, Decode = 1, MemAdr = 2;
  logic [3:0] MemRead = 3, MemWB = 4, _MemWrite = 5;
  logic [3:0] ExecuteR = 6, ALUWB = 7, ExecuteI = 8;
  logic [3:0] JAL = 9, BEQ = 10, LUI = 11;

  always @(posedge clk, posedge reset)
    if (reset)
      ps <= Fetch;
    else
      ps <= ns;
  


  always @(ps, op)begin
    case(ps)
      Fetch:
        ns = Decode;
      Decode:
        case(op)
          7'b0000011: ns = MemAdr; // lw
          7'b1000011: ns = Fetch; // jarl
          7'b0100011: ns = MemAdr; // sw
          7'b0110011: ns = ExecuteR; // R–type
          7'b1100011: ns = BEQ; // beq
          7'b0010011: ns = ExecuteI; // I–type ALU
          7'b1101111: ns = JAL; // jal
          7'b0110111: ns = LUI; // lui
          default   : ns = Fetch; // ???
        endcase
      MemAdr:
        case(op)
          7'b0000011: ns = MemRead; // lw
          7'b0100011: ns = _MemWrite; // sw
        endcase
      MemRead:
        ns = MemWB;
      MemWB:
        ns = Fetch;
      _MemWrite:
        ns = Fetch;
      ExecuteR:
        ns = ALUWB;
      ALUWB:  
        ns = Fetch;
      ExecuteI:
        ns = ALUWB;
      JAL:
        ns = ALUWB;
      BEQ:
        ns = Fetch;
      LUI:
        ns = Fetch;
    endcase
  end

  always @(ps)begin
    {Branch, PCUpdate, RegWrite, MemWrite, IRWrite, AdrSrc} = 7'd0;
    {ResultSrc, ALUSrcA, ALUSrcB} = 6'd0;
    case(ps)
      Fetch: begin
        AdrSrc = 1'b0;
        IRWrite = 1'b1;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b10;
        ALUOp = 2'b00;
        ResultSrc = 2'b10;
        PCUpdate = 1'b1;
      end
      Decode: begin
        ALUSrcA = 2'b01;
        ALUSrcB = 2'b01;
        ALUOp = 2'b00;
      end
      MemAdr: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b01;
        ALUOp = 2'b00;
      end
      MemRead: begin
        ResultSrc = 2'b00;
        AdrSrc = 1'b1;
      end
      MemWB: begin
        ResultSrc = 2'b01;
        RegWrite = 1'b1;
      end
      _MemWrite: begin
        ResultSrc = 2'b00;
        AdrSrc = 1'b1;
        MemWrite = 1'b1;
      end
      ExecuteR: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b00;
        ALUOp = 2'b10;
      end
      ALUWB: begin
        ResultSrc = 2'b00;
        RegWrite = 1'b1;
      end
      ExecuteI: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b01;
        ALUOp = 2'b10;
      end
      JAL: begin
        ALUSrcA = 2'b01;
        ALUSrcB = 2'b10;
        ALUOp = 2'b00;
        ResultSrc = 2'b00;
        PCUpdate = 1'b1;
      end
      BEQ: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b00;
        ALUOp = 2'b01;
        ResultSrc = 2'b00;
        Branch = 1'b1;
      end
      LUI: begin
        RegWrite = 1'b1;
        ResultSrc = 2'b11; 
      end
    endcase
  end

endmodule