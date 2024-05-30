`timescale 1ns / 1ps

module control_tb;

  // Inputs
  reg [8:0] instruction;

  // Outputs
  wire branchFlag, memToRegFlag, memWriteFlag, regWriteFlag, putFlag, immtoRegFlag;
  wire [3:0] ALUOp;

  // Instantiate the Control module
  Control uut (
    .instruction(instruction),
    .branchFlag(branchFlag),
    .memToRegFlag(memToRegFlag),
    .memWriteFlag(memWriteFlag),
    .regWriteFlag(regWriteFlag),
    .putFlag(putFlag),
    .immtoRegFlag(immtoRegFlag),
    .ALUOp(ALUOp)
  );

  // Test sequence
  initial begin
    // Initialize inputs
    instruction = 9'b0;

    // Test various instructions
    instruction = 9'b000000000; // No operation
    #10;
    $display("Test NOP: Expected ALUOp=0111, Got %b", ALUOp);

    instruction = 9'b000000001; // Load from memory
    #10;
    $display("Test Load: Expected memToRegFlag=1, Got %b", memToRegFlag);

    instruction = 9'b000000010; // Store to memory
    #10;
    $display("Test Store: Expected memWriteFlag=1, Got %b", memWriteFlag);

    instruction = 9'b000000011; // Add
    #10;
    $display("Test Add: Expected ALUOp=0101, Got %b", ALUOp);

    instruction = 9'b000000100; // Subtract
    #10;
    $display("Test Subtract: Expected ALUOp=0110, Got %b", ALUOp);

    instruction = 9'b000000101; // XOR
    #10;
    $display("Test XOR: Expected ALUOp=0001, Got %b", ALUOp);

    instruction = 9'b000000110; // OR
    #10;
    $display("Test OR: Expected ALUOp=0010, Got %b", ALUOp);

    instruction = 9'b000000111; // AND
    #10;
    $display("Test AND: Expected ALUOp=0000, Got %b", ALUOp);

    instruction = 9'b000001000; // Jump
    #10;
    $display("Test Jump: Expected branchFlag=1, Got %b", branchFlag);

    // Finish simulation
    $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, Instruction = %b, BranchFlag = %b, MemToRegFlag = %b, MemWriteFlag = %b, RegWriteFlag = %b, PutFlag = %b, ImmtoRegFlag = %b, ALUOp = %b",
             $time, instruction, branchFlag, memToRegFlag, memWriteFlag, regWriteFlag, putFlag, immtoRegFlag, ALUOp);
  end

endmodule
