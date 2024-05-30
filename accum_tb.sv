`timescale 1ns / 1ps

module Accumulator_tb;

  // Inputs
  reg clk;
  reg reset;
  reg putFlag;
  reg [7:0] value;

  // Outputs
  wire [7:0] r0;
  wire [7:0] r1;
  wire [7:0] r2;
  wire done;

  // Instantiate the Accumulator module
  Accumulator uut (
    .clk(clk),
    .reset(reset),
    .putFlag(putFlag),
    .value(value),
    .r0(r0),
    .r1(r1),
    .r2(r2),
    .done(done)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 ns
  end

  // Test sequence
  initial begin
    // Initialize inputs
    reset = 1;
    putFlag = 0;
    value = 0;
    #10;
    reset = 0;

    // Test 1: Accumulate three values
    putFlag = 1;
    value = 8'd10; // First value
    #10;
    value = 8'd20; // Second value
    #10;
    value = 8'd30; // Third value
    #10;
    putFlag = 0;

    // Check results
    #10;
    if (r0 == 8'd10 && r1 == 8'd20 && r2 == 8'd30 && done == 1) begin
      $display("Test Passed: Accumulation correct.");
    end else begin
      $display("Test Failed: Accumulation incorrect.");
    end

    // Finish simulation
    $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, Reset = %b, PutFlag = %b, Value = %b, r0 = %b, r1 = %b, r2 = %b, Done = %b",
             $time, reset, putFlag, value, r0, r1, r2, done);
  end

endmodule
