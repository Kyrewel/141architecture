module PC_LUT(
  input [7:0] tag,       // target 4 values
  output logic [11:0] target
);

logic [11:0] tagToTarget[2**12]; // Memory array for 4096 entries of 12 bits each

initial begin
    $readmemb("tag_to_instruction_line.txt", tagToTarget); // Load data into memory
end

always_comb target = tagToTarget[tag]; // Assign the output based on the tag input

endmodule