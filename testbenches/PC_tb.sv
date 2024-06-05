module PC_tb;

  parameter D = 12;
  reg reset, clk, absjump_en;
  reg [D-1:0] target;
  logic [D-1:0] prog_ctr;

  // Instantiate the PC module
  PC #(.D(D)) uut (
    .reset(reset),
    .clk(clk),
    .absjump_en(absjump_en),
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
    reset = 1; absjump_en = 0; target = 0;
    #10; // Wait for a clock edge
    reset = 0;
    // takes one cycle to update flag inside PC, then will start updating prog_ctr correctly next cycle

    for (int i = 0; i < 15; i++) begin
        #30; 
    end

    $finish;
  end

  // Monitor program counter
  initial begin
    $monitor("Time=%t, prog_ctr=%h", $time, prog_ctr);
  end
endmodule
