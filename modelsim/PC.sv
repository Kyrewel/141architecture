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
  logic [3:0] numCyclesPassed = 0;
  logic [D-1:0] counter = 0;
  
  always_ff @(posedge clk) begin
    if (reset) begin
      counter <= 0;
      numCyclesPassed <= 0;
    end else if (numCyclesPassed % 6 === 0) begin
      if (branchFlag) begin
        $info("PC: branching to: %d", target);
        counter <= target;
      end else begin
        $info("PC: incrementing ctr: %d", counter + 1);
        counter <= counter + 1;
      end
    end
    prog_ctr <= counter; // Update every cycle
    numCyclesPassed <= numCyclesPassed + 1;
  end

endmodule
