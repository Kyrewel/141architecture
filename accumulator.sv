module accumulator(
    input wire clk,    // Clock input
    input wire reset,  // Reset input
    input wire put,    // Put signal to trigger accumulation
    input wire [7:0] value, // 8-bit input value
    output reg [7:0] r0,    // 8-bit output register r0
    output reg [7:0] r1,    // 8-bit output register r1
    output reg [7:0] r2,    // 8-bit output register r2
    output reg done         // 1-bit done flag
);

reg r0_valid, r1_valid; // Flags to indicate if r1 and r2 have values stored

initial begin
    r0_valid = 0;
    r1_valid = 0;
end

// Implement the accumulator logic here
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset logic
        r0 <= 0;
        r1 <= 0;
        r2 <= 0;
        r0_valid <= 0;
        r1_valid <= 0;
        done <= 0;
    end else if (put) begin
        // Accumulation logics
        if (!r0_valid) begin
            r0 <= value;
            r0_valid <= 1;
        end else if (!r1_valid) begin
            r1 <= value;
            r1_valid <= 1;
        end else begin
            r2 <= value;
        end
        done <= 1; // Set done when a put operation completes
    end
end

endmodules