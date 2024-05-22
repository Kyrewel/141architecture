// Testbench for ALU
`timescale 1ns / 1ps

module alu_tb;

  // Inputs
  reg [3:0] alu_cmd;
  reg [7:0] inA, inB;
  reg shiftcarry_in;

  // Outputs
  wire [7:0] rslt;
  wire shiftcarry_out;

  // Instantiate the ALU module
  alu uut (
    .alu_cmd(alu_cmd),
    .inA(inA),
    .inB(inB),
    .shiftcarry_in(shiftcarry_in),
    .rslt(rslt),
    .shiftcarry_out(shiftcarry_out)
  );

  // Test sequence
  initial begin
    // Initialize inputs
    inA = 0;
    inB = 0;
    shiftcarry_in = 0;
    alu_cmd = 0;

    // Apply test vectors
    #10 inA = 8'b10101010; inB = 8'b01010101; shiftcarry_in = 1'b0;

    // Test AND
    alu_cmd = 4'b0000;
    #10;

    // Test XOR
    alu_cmd = 4'b0001;
    #10;

    // Test OR
    alu_cmd = 4'b0010;
    #10;

    // Test logical left shift
    alu_cmd = 4'b0011;
    #10;

    // Test logical right shift
    alu_cmd = 4'b0100;
    #10;

    // Test ADD
    alu_cmd = 4'b0101;
    #10;

    // Test SUBTRACT
    alu_cmd = 4'b0110;
    #10;

    // Test PASS A
    alu_cmd = 4'b0111;
    #10;

    // Finish simulation
    $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, Command = %b, inA = %b, inB = %b, Shift Carry In = %b, Result = %b, Shift Carry Out = %b",
             $time, alu_cmd, inA, inB, shiftcarry_in, rslt, shiftcarry_out);
  end

endmodule