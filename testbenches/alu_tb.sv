module alu_tb;

  // Inputs
  reg [3:0] ALUOp;
  reg [7:0] inA, inB;
  reg shiftcarry_in;
  reg [11:0] reg_file_ctr;

  // Outputs
  wire [7:0] rslt;
  wire shiftcarry_out;
  wire branchFlag;
  wire [11:0] alu_ctr;

  // Instantiate the ALU module
  alu uut (
    .ALUOp(ALUOp),
    .inA(inA),
    .inB(inB),
    .shiftcarry_in(shiftcarry_in),
    .reg_file_ctr(reg_file_ctr),
    .rslt(rslt),
    .shiftcarry_out(shiftcarry_out),
    .branchFlag(branchFlag),
    .alu_ctr(alu_ctr)
  );

  // Test sequence
  initial begin
    // Initialize inputs
    ALUOp = 4'b0000; // AND operation
    inA = 8'b10101010;
    inB = 8'b11001100;
    shiftcarry_in = 0;
    reg_file_ctr = 12'b000000000001;
    #10;
    $display("Test AND: Expected Result=10001000, Got %b", rslt);

    ALUOp = 4'b0001; // XOR operation
    inA = 8'b10101010;
    inB = 8'b11001100;
    #10;
    $display("Test XOR: Expected Result=01100110, Got %b", rslt);

    ALUOp = 4'b0010; // OR operation
    inA = 8'b10101010;
    inB = 8'b11001100;
    #10;
    $display("Test OR: Expected Result=11101110, Got %b", rslt);

    ALUOp = 4'b0101; // ADD operation
    inA = 8'b00000001;
    inB = 8'b00000001;
    #10;
    $display("Test ADD: Expected Result=00000010, Got %b", rslt);

    ALUOp = 4'b0110; // SUB operation
    inA = 8'b00000010;
    inB = 8'b00000001;
    #10;
    $display("Test SUB: Expected Result=00000001, Got %b", rslt);

    ALUOp = 4'b1001; // EQUAL TO operation
    inA = 8'b00000010;
    inB = 8'b00000010;
    #10;
    $display("Test EQUAL TO: Expected BranchFlag=1, Got %b", branchFlag);

    ALUOp = 4'b1010; // SUB operation with carry in
    inA = 8'b00000010;
    inB = 8'b00000001;
    shiftcarry_in = 1;
    #10;
    $display("Test SUB with carry in: Expected Result=00000010, Got %b", rslt);

    // Complete the test
    $finish;
  end

endmodule
