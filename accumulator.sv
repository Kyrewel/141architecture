module Accumulator(
    input wire clk,    // Clock input
    input wire putFlag,    // Put signal to trigger accumulation
    input wire [7:0] value, // 8-bit input value
    output logic [7:0] r0,    // 8-bit output register r0
    output logic [7:0] r1,    // 8-bit output register r1
    output logic [7:0] r2,    // 8-bit output register r2
    output logic done         // 1-bit done flag
);

logic r0_valid, r1_valid; // Flags to indicate if r1 and r2 have values stored

initial begin
    logic [7:0] internal_reg0; // Internal register 0
    logic [7:0] internal_reg1; // Internal register 1
    logic [7:0] internal_reg2; // Internal register 2
    r0_valid = 0;
    r1_valid = 0;
end

// Implement the accumulator logic here
always @(posedge clk or posedge reset) begin
    if (putFlag) begin
        // Accumulation logics
        if (!r0_valid) begin
            internal_reg0 <= value;
            r0_valid <= 1;
        end else if (!r1_valid) begin
            internal_reg1 <= value;
            r1_valid <= 1;
        end else begin
            internal_reg2 <= value;
        end
        done <= 1;
    end else begin
        r0 <= internal_reg0;
        r1 <= internal_reg1;
        r2 <= internal_reg2;
        internal_reg0 <= 0;
        internal_reg1 <= 0;
        internal_reg2 <= 0;
    end
    
end
endmodule
