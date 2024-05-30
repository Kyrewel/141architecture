`timescale 1ns / 1ps

module dat_mem_tb;

  // Inputs
  reg [7:0] dat_in;
  reg clk;
  reg wr_en;
  reg [7:0] addr;

  // Outputs
  wire done;
  wire [7:0] dat_out;

  // Instantiate the dat_mem module
  dat_mem uut (
    .dat_in(dat_in),
    .clk(clk),
    .wr_en(wr_en),
    .addr(addr),
    .done(done),
    .dat_out(dat_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize inputs
    dat_in = 0;
    wr_en = 0;
    addr = 0;

    // Test Case 1: Write and Read from Memory
    #10;
    dat_in = 8'hAA; // Test data
    addr = 8'h10;   // Test address
    wr_en = 1;      // Enable write
    #10;
    wr_en = 0;      // Disable write
    #10;
    $display("Test Write: Address %h, Data Written %h", addr, dat_in);
    #10;
    $display("Test Read: Address %h, Data Read %h", addr, dat_out);
    if (dat_out == dat_in) begin
      $display("Test Case 1 Passed");
    end else begin
      $display("Test Case 1 Failed");
    end

    // Test Case 2: Check done signal
    #10;
    dat_in = 8'hFF; // New test data
    addr = 8'h20;   // New test address
    wr_en = 1;      // Enable write
    #10;
    if (done) begin
      $display("Test Case 2 Passed: Done signal asserted correctly");
    end else begin
      $display("Test Case 2 Failed: Done signal not asserted");
    end
    wr_en = 0;      // Disable write

    // Finish the simulation
    #20;
    $finish;
  end

endmodule
