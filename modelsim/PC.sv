// program counter
// supports both relative and absolute jumps
// use either or both, as desired
//
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
        branchFlag,				// abs. jump enable
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);
  logic [4:0] numCyclesPassed = 1;
  logic [D-1:0] counter = 0;
  
  always_ff @(posedge clk) begin
    if (reset) begin
      $display("PC: resetting");
      counter <= 0;
      numCyclesPassed <= 1;
    end else if (numCyclesPassed % 10 == 0) begin
      if (branchFlag) begin
        $display("PC: branching to: %d", target);
        counter <= target;
        numCyclesPassed <= 1;
      end else begin
        $display("PC: time: %t incrementing ctr: %d", $time, counter + 1);
        counter <= counter + 1;
        numCyclesPassed <= 1;
      end
    end
    prog_ctr <= counter; // Update every cycle
    numCyclesPassed <= numCyclesPassed + 1;
  end

endmodule
