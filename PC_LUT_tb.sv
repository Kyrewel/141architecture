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

    // Display the machine code at different addresses
    $display("Testing PC_LUT with various program counter values:");
    repeat (16) begin
      #10; // Wait for 10 time units
      $display("At prog_ctr = %d, mach_code = %b", prog_ctr, mach_code);
      prog_ctr = prog_ctr + 1; // Increment program counter
    end

    // Finish the simulation
    #20;
    $finish;
  end

endmodule
