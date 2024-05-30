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
    instruction = 9'b000000000; //load imm
    #10;
    $display("Test load imm: Expected ALUOp=0111, Got %b", ALUOp);
    $display("Test load imm: Expected immtoRegFlag=1, Got %b", immtoRegFlag);

    instruction = 9'b000000010; //load mem
    #10;
    $display("Test load mem: Expected ALUOp=0111, Got %b", ALUOp);
    $display("Test load mem: Expected memToRegFlag=1, Got %b", memToRegFlag);

    instruction = 9'b000000100; //store to mem
    #10;
    $display("Test store mem: Expected ALUOp=0111, Got %b", ALUOp);
    $display("Test store mem: Expected memWriteFlag=1, Got %b", memWriteFlag);
    $display("Test store mem: Expected regWriteFlag=0, Got %b", regWriteFlag);

    instruction = 9'b000000110; // add
    #10;
    $display("Test add: Expected ALUOp=0101, Got %b", ALUOp);
    
    instruction = 9'b000001000; // sub
    #10;
    $display("Test sub: Expected ALUOp=0110, Got %b", ALUOp);

    instruction = 9'b000001010; // xor
    #10;
    $display("Test xor: Expected ALUOp=0001, Got %b", ALUOp);

    instruction = 9'b000001100; // or
    #10;
    $display("Test or: Expected ALUOp=0010, Got %b", ALUOp);

    instruction = 9'b000001110; // and
    #10;
    $display("Test store mem: Expected ALUOp=0000, Got %b", ALUOp);

    instruction = 9'b000010000; // jump
    #10;
    $display("Test jump: Expected ALUOp=0111, Got %b", ALUOp);
    $display("Test jump: Expected regWriteFlag=0, Got %b", regWriteFlag);
    $display("Test jump: Expected branchFlag=1, Got %b", branchFlag);

    instruction = 9'b000010010; // beq
    #10;
    $display("Test beq: Expected ALUOp=1010, Got %b", ALUOp);
    $display("Test beq: Expected regWriteFlag=0, Got %b", regWriteFlag);

    instruction = 9'b000010100; // blt
    #10;
    $display("Test blt: Expected ALUOp=1000, Got %b", ALUOp);
    $display("Test blt: Expected regWriteFlag=0, Got %b", regWriteFlag);

    instruction = 9'b000010110; // bgt
    #10;
    $display("Test bgt: Expected ALUOp=1001, Got %b", ALUOp);
    $display("Test bgt: Expected regWriteFlag=0, Got %b", regWriteFlag);

    instruction = 9'b000011000; // ls
    #10;
    $display("Test ls: Expected ALUOp=0011, Got %b", ALUOp);

    instruction = 9'b000011010; // rs
    #10;
    $display("Test rs: Expected ALUOp=0100, Got %b", ALUOp);

    // Finish simulation
    $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, Instruction = %b, BranchFlag = %b, MemToRegFlag = %b, MemWriteFlag = %b, RegWriteFlag = %b, PutFlag = %b, ImmtoRegFlag = %b, ALUOp = %b",
             $time, instruction, branchFlag, memToRegFlag, memWriteFlag, regWriteFlag, putFlag, immtoRegFlag, ALUOp);
  end

endmodule
