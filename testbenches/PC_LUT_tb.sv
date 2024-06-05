`timescale 1ns / 1ps

module PC_LUT_tb;

  // Inputs
  reg [7:0] tag;

  // Outputs
  wire [11:0] target;

  // Instantiate the PC_LUT module
  PC_LUT uut (
    .tag(tag),
    .target(target)
  );

  // Test sequence
  initial begin
    #10;

    tag = 1;

    #10;

    $display("tag = %b", target);
    if (target == 'b000000000000) begin
      $display("Test Case 1 Passed");
    end
    else begin
      $display("Test Case 1 Failed");
    end

    $finish;
  end

endmodule
