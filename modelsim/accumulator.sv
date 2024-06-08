module Accumulator(
    input wire clk,    // Clock input
    input wire putEn,    // Put signal to trigger accumulation
    input wire opEn,     // Op signal to trigger output
    input wire [7:0] value, // 8-bit input value
    input wire [11:0] prog_ctr,

    output logic [7:0] r0,    // 8-bit output register r0
    output logic [7:0] r1,    // 8-bit output register r1
    output logic [7:0] r2,    // 8-bit output register r2
    output logic r0_valid,    // Validity flag for r0
    output logic r1_valid,    // Validity flag for r1
    output logic r2_valid    // Validity flag for r2
);

logic [11:0] oldPC = -1;

initial begin
    r0_valid = 0;
    r1_valid = 0;
    r2_valid = 0;
end
// Implement the accumulator logic here
always @(posedge clk) begin
    if (oldPC !== prog_ctr) begin
        oldPC <= prog_ctr;
        if (putEn && !opEn) begin
            // Accumulation logics
            if (!r0_valid) begin
                $info("AC: time=%t putting %d in r0", $time, value);
                r0 <= value;
                r0_valid <= 1;
            end else if (!r1_valid) begin
                $info("AC: time=%t putting %d in r1", $time, value);
                r1 <= value;
                r1_valid <= 1;
            end else if (!r2_valid) begin
                $info("AC: time=%t putting %d in r2", $time, value);
                r2 <= value;
                r2_valid <= 1;
            end
        end else if (opEn && !putEn) begin
            $info("AC: time=%t resetting valid bits", $time);
            r0_valid <= 0;
            r1_valid <= 0;
            r2_valid <= 0;
        end else begin
            // $error("ERROR:: PUT AND OP ENABLE BOTH ARE ACTIVE OR INACTIVE");
        end 
        $info("AC: values - time=%t, r0: %d, r1: %d, r2: %d, r0_valid: %b, r1_valid: %b, r2_valid: %b", $time, r0, r1, r2, r0_valid, r1_valid, r2_valid);
    end
end
endmodule
