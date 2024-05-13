module PC_LUT(
  input[7:0] tag,	   // target 4 values
  output logic[11:0] target
);

logic[11:0] tagToTarget[2**12];

initial begin
	$readmemb("tag_to_instruction_line.txt", tagToTarget);
end

always_comb target = tagToTarget[tag];

endmodule