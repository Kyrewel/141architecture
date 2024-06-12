module Accumulator(
    input wire clk,    // Clock input
    input wire putEn,    // Put signal to trigger accumulation
    input wire opEn,     // Op signal to trigger output
    input wire [7:0] value, // 8-bit input value
    input wire [11:0] control_ctr,

    output logic [7:0] r0,    // 8-bit output register r0
    output logic [7:0] r1,    // 8-bit output register r1
    output logic [7:0] r2,    // 8-bit output register r2
    output logic [11:0]accumulator_ctr
);

logic [12-1:0] old_control_ctr = -1;
logic r0_valid = 0;
logic r1_valid = 0;
logic r2_valid = 0;

// Implement the accumulator logic here
always_comb begin
    if (control_ctr !== old_control_ctr) begin
        old_control_ctr = control_ctr;
        if (putEn && !opEn) begin
            // Accumulation logics
            if (!r0_valid) begin
                $display("AC: time=%t putting %d in r0", $time, value);
                r0 = value;
                r0_valid = 1;
            end else if (!r1_valid) begin
                $display("AC: time=%t putting %d in r1", $time, value);
                r1 = value;
                r1_valid = 1;
            end else if (!r2_valid) begin
                $display("AC: time=%t putting %d in r2", $time, value);
                r2 = value;
                r2_valid = 1;
            end
        end else if (opEn && !putEn) begin
            $display("AC: time=%t resetting valid bits", $time);
            r0_valid = 0;
            r1_valid = 0;
            r2_valid = 0;
        end else begin
            // $error("ERROR:: PUT AND OP ENABLE BOTH ARE ACTIVE OR INACTIVE");
        end 
        old_control_ctr = control_ctr;
        accumulator_ctr = control_ctr;
        $monitor("AC: values -- r0: %d, r1: %d, r2: %d, r0_valid: %b, r1_valid: %b, r2_valid: %b", r0, r1, r2, r0_valid, r1_valid, r2_valid);
    end
end
endmodule
