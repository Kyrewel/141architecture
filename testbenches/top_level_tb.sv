module top_level_tb;

  // Inputs
  reg clk;
  reg reset;
  reg req;

  // Outputs
  wire done;

  // Instantiate the Unit Under Test (UUT)
  top_level uut (
    .clk(clk),
    .reset(reset),
    .req(req),
    .done(done)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period of 10 time units
  end

  // Reset generation
  initial begin
    reset = 1;
    #15 reset = 0; // Reset is asserted for 15 time units
  end

  // Test sequence
  initial begin
    req = 0;
    #20;
    req = 1; // Send a request signal
    #10;
    req = 0;
    #100; // Wait for 100 time units to observe the behavior
    $finish; // End the simulation
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, Reset = %b, Request = %b, Done = %b", $time, reset, req, done);
  end

endmodule
