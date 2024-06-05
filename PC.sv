// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
        absjump_en,				// abs. jump enable
        nextFlag,
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);
  logic [D-1:0] counter;

  always_ff @(posedge clk) begin
    if (reset) begin
      counter <= 0;
    end else if (nextFlag) begin
      if (absjump_en)
        counter <= target;
      else
        counter <= counter + 1;
    end
    prog_ctr <= counter; // Update every cycle
  end
endmodule
