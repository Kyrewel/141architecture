`timescale 1ns / 1ps

module PC_LUT_tb;

  // Parameters
  parameter D = 12; // Depth of the LUT

  // Inputs
  reg [D-1:0] prog_ctr;

  // Outputs
  wire [8:0] mach_code;

  // Instantiate the PC_LUT module
  PC_LUT #(.D(D)) uut (
    .prog_ctr(prog_ctr),
    .mach_code(mach_code)
  );

  // Test sequence
  initial begin
    // Initialize inputs
    prog_ctr = 0;

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
