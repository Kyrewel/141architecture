module top_level_tb;

  // Inputs
  reg clk;
  reg reset;
  reg req;

  // Outputs
  wire done;

  // Instantiate the Unit Under Test (UUT)
  top_level tl (
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

  always_comb begin
    if (done) begin
      $finish;
    end
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, Reset = %b, Request = %b, Done = %b", $time, reset, req, done);
  end

endmodule
