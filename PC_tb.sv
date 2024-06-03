module PC_tb;

  parameter D = 12;
  reg reset, clk, absjump_en, nextFlag;
  reg [D-1:0] target;
  wire [D-1:0] prog_ctr;

  // Instantiate the PC module
  PC #(.D(D)) uut (
    .reset(reset),
    .clk(clk),
    .absjump_en(absjump_en),
    .nextFlag(nextFlag),
    .target(target),
    .prog_ctr(prog_ctr)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    reset = 1; absjump_en = 0; nextFlag = 0; target = 0;
    @(posedge clk);
    reset = 0; nextFlag = 1; // Enable nextFlag to test counter increment
    @(posedge clk);
    @(posedge clk);
    $display("Test 1 - Increment: prog_ctr should be 1, actual %d", prog_ctr);
    if (prog_ctr !== 1) $display("Test failed: prog_ctr is not incrementing correctly.");
    else $display("Test passed: prog_ctr is incrementing correctly.");

    $finish;
  end

endmodule
