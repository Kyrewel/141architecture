// program counter
// supports both relative and absolute jumps
// use either or both, as desired
//
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
        branchFlag,				// abs. jump enable
        pc_print,
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);
  logic [4:0] numCyclesPassed = 1;
  logic [D-1:0] counter = 0;
  logic [15:0] cyclesToPrint = 0;
  
  always_ff @(posedge clk) begin
    // if (cyclesToPrint % 1000000000 == 0) begin
    //   $display("PC: time: %t", $time);
    //   cyclesToPrint <= 0;
    // end
    if (reset) begin
      if (pc_print) begin
        $display("PC: resetting");
      end
      counter <= 0;
      numCyclesPassed <= 1;
    end else if (numCyclesPassed % 5 == 0) begin
      if (branchFlag) begin
        if (pc_print) begin
          $display("PC: branching to: %d", target);
        end
        counter <= target;
        numCyclesPassed <= 1;
      end else begin
        if (pc_print) begin
          $display("PC: time: %t incrementing ctr: %d", $time, counter + 1);
        end
        counter <= counter + 1;
        numCyclesPassed <= 1;
      end
    end
    prog_ctr <= counter; // Update every cycle
    numCyclesPassed <= numCyclesPassed + 1;
    cyclesToPrint <= cyclesToPrint + 1;
  end

endmodule
