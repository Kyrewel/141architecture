module PC_tb;

  parameter D = 12;
  reg reset, clk, absjump_en, nextFlag;
  reg [D-1:0] target;
  logic [D-1:0] prog_ctr;

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
    #10; // Wait for a clock edge
    reset = 0; nextFlag = 1; // Enable nextFlag to test counter increment

    // takes one cycle to update flag inside PC, then will start updaing prog_ctr correctly next cycle

    for (int i = 0; i <= 15; i++) begin
        #10; 
        $display("Test %d - Increment: prog_ctr should be %d, actual %d", i, i, prog_ctr);
        if (prog_ctr !== i) $display("Test failed: prog_ctr is not incrementing correctly at cycle %d.", i);
        else $display("Test passed: prog_ctr is incrementing correctly at cycle %d.", i);
    end

    $finish;
  end

endmodule
