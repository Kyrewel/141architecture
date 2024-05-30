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
    inA = 8'b10101010; inB = 8'b01010101; shiftcarry_in = 1'b0;

    // Test AND
    alu_cmd = 4'b0000;
    #1 $display("Test AND: Expected %b, Got %b", inA & inB, rslt);

    // Test XOR
    alu_cmd = 4'b0001;
    #1 $display("Test XOR: Expected %b, Got %b", inA ^ inB, rslt);

    // Test OR
    alu_cmd = 4'b0010;
    #1 $display("Test OR: Expected %b, Got %b", inA | inB, rslt);

    // Test logical left shift
    alu_cmd = 4'b0011;
    #1 $display("Test logical left shift: Expected %b, Got %b", inA << 1, rslt);

    // Test logical right shift
    alu_cmd = 4'b0100;
    #1 $display("Test logical right shift: Expected %b, Got %b", inA >> 1, rslt);

    // Test ADD
    alu_cmd = 4'b0101;
    #1 $display("Test ADD: Expected %b, Got %b", inA + inB, rslt);

    // Test SUBTRACT
    alu_cmd = 4'b0110;
    #1 $display("Test SUBTRACT: Expected %b, Got %b", inA - inB, rslt);

    // Test PASS A
    alu_cmd = 4'b0111;
    #1 $display("Test PASS A: Expected %b, Got %b", inA, rslt);

    // Finish simulation
    $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, Command = %b, inA = %b, inB = %b, Shift Carry In = %b, Result = %b, Shift Carry Out = %b",
             $time, alu_cmd, inA, inB, shiftcarry_in, rslt, shiftcarry_out);
  end

endmodule