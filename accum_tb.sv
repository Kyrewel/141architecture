`timescale 1ns / 1ps

module Accumulator_tb;

  // Inputs
  reg clk;
  reg putFlag;
  reg [7:0] value;

  // Outputs
  wire [7:0] r0;
  wire [7:0] r1;
  wire [7:0] r2;
  wire r0_valid;
  wire r1_valid;
  wire r2_valid;
  wire done;

  // Instantiate the Accumulator module
  Accumulator uut (
    .clk(clk),
    .putFlag(putFlag),
    .value(value),
    .r0(r0),
    .r1(r1),
    .r2(r2),
    .r0_valid(r0_valid),
    .r1_valid(r1_valid),
    .r2_valid(r2_valid),
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
    putFlag = 0;
    value = 0;
    #10;

    // Test 1: Accumulate one value
    putFlag = 1;
    value = 8'd10; // First value
    #10;
    putFlag = 0;
    #10;

    // Test 1.5: Check reset of valid bits
    if (!r0_valid && !r1_valid && !r2_valid) begin
      $display("Test 1.5 Passed: Valid bits reset correctly.");
    end else begin
      $display("Test 1.5 Failed: Valid bits did not reset correctly.");
    end

    // Test 2: Accumulate two values
    putFlag = 1;
    value = 8'd20; // First value
    #10;
    value = 8'd30; // Second value
    #10;
    putFlag = 0;
    #10;

    // Test 2.5: Check reset of valid bits
    if (!r0_valid && !r1_valid && !r2_valid) begin
      $display("Test 2.5 Passed: Valid bits reset correctly.");
    end else begin
      $display("Test 2.5 Failed: Valid bits did not reset correctly.");
    end

    // Test 3: Accumulate three values
    putFlag = 1;
    value = 8'd40; // First value
    #10;
    value = 8'd50; // Second value
    #10;
    value = 8'd60; // Third value
    #10;
    putFlag = 0;


    // Test 3.5: Check reset of valid bits
    if (!r0_valid && !r1_valid && !r2_valid) begin
      $display("Test 3.5 Passed: Valid bits reset correctly.");
    end else begin
      $display("Test 3.5 Failed: Valid bits did not reset correctly.");
    end

    // Check results
    #10;
    if (r0 == 8'd40 && r1 == 8'd50 && r2 == 8'd60 && !r0_valid && !r1_valid && !r2_valid && done == 0) begin
      $display("Test Passed: Accumulation correct.");
    end else begin

      $display("Test Failed: Accumulation incorrect.");
    end

    // Finish simulation
    $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, PutFlag = %b, Value = %b, r0 = %b, r1 = %b, r2 = %b, r0_valid = %b, r1_valid = %b, r2_valid = %b, Done = %b",
             $time, putFlag, value, r0, r1, r2, r0_valid, r1_valid, r2_valid, done);
  end

endmodule
