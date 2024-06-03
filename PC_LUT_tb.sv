`timescale 1ns / 1ps

module PC_LUT_tb;

  // Inputs
  reg [7:0] tag,

  // Outputs
  wire [11:0] target;

  // Instantiate the PC_LUT module
  PC_LUT #(.D(D)) uut (
    .tag(tag),
    .target(target)
  );

  // Test sequence
  initial begin

    tag = 1;
    if (target == 'b000000000000) begin
      $display("Test Case 1 Passed");
    end

    $finish;
  end

endmodule
