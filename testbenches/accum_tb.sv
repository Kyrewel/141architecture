module accum_tb;

  reg clk, reset, putEn, opEn;
  reg [7:0] value;
  wire [7:0] r0, r1, r2;
  wire r0_valid, r1_valid, r2_valid;

  // Instantiate the Accumulator
  Accumulator acc(
    .clk(clk),
    .prog_ctr(prog_ctr),
    .putEn(putEn),
    .opEn(opEn),
    .value(value),
    .r0(r0),
    .r1(r1),
    .r2(r2),
    .r0_valid(r0_valid),
    .r1_valid(r1_valid),
    .r2_valid(r2_valid)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    reset = 1; putEn = 0; opEn = 0; value = 0;
    #10 reset = 0; // Release reset

    // Test accumulation
    #10 putEn = 1; value = 8'hAA; // Load first value
    #10 putEn = 1; value = 8'h55; // Load second value
    #10 putEn = 1; value = 8'hFF; // Load third value
    #10 putEn = 0; opEn = 1; // Trigger output enable
    #10 putEn = 1; opEn = 0; value = 8'h10; 
    #10 putEn = 0; opEn = 0; // reset flags

    // Finish test
    #30 $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%t clk=%b putEn=%b opEn=%b value=%h r0=%h r1=%h r2=%h r0_valid=%b r1_valid=%b r2_valid=%b",
             $time, clk, putEn, opEn, value, r0, r1, r2, r0_valid, r1_valid, r2_valid);
  end

endmodule
