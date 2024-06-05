module Accumulator(
    input wire clk,    // Clock input
    input wire putFlag,    // Put signal to trigger accumulation
    input wire [7:0] value, // 8-bit input value

    output logic [7:0] r0,    // 8-bit output register r0
    output logic [7:0] r1,    // 8-bit output register r1
    output logic [7:0] r2,    // 8-bit output register r2
    output logic r0_valid,    // Validity flag for r0
    output logic r1_valid,    // Validity flag for r1
    output logic r2_valid,    // Validity flag for r2
    output logic done         // 1-bit done flag
);

logic [7:0] internal_reg0; // Internal register 0
logic [7:0] internal_reg1; // Internal register 1
logic [7:0] internal_reg2; // Internal register 2

initial begin
    r0_valid = 0;
    r1_valid = 0;
    r2_valid = 0;
    internal_reg0 = 0;
    internal_reg1 = 0;
    internal_reg2 = 0;
end

// Implement the accumulator logic here
always @(posedge clk) begin
    $info("************************ ACCUMULATOR MODULE *************************");
    if (putFlag) begin
        // Accumulation logics
        if (!r0_valid) begin
            $info("SETTING INTERNAL_REG0 ------ value: %d", value);
            internal_reg0 <= value;
            r0_valid <= 1;
        end else if (!r1_valid) begin
            $info("SETTING INTERNAL_REG1 ------ value: %d", value);
            internal_reg1 <= value;
            r1_valid <= 1;
        end else if (!r2_valid) begin
            $info("SETTING INTERNAL_REG2 ------ value: %d", value);
            internal_reg2 <= value;
            r2_valid <= 1;
        end
        $info("PUTTING VALUE ------ internal_reg0: %d, internal_reg1: %d, internal_reg2: %d", internal_reg0, internal_reg1, internal_reg2);
        $info("VALID VALUES ------ r0_valid: %b, r1_valid: %b, r2_valid: %b", r0_valid, r1_valid, r2_valid);
        done <= 1;
    end else begin
        r0 <= internal_reg0;
        r1 <= internal_reg1;
        r2 <= internal_reg2;
        $info("COMMAND READY ------ r0: %d, r1: %d, r2: %d", r0, r1, r2);
        r0_valid <= 0;
        r1_valid <= 0;
        r2_valid <= 0;
        done <= 0;
    end
end
endmodule
