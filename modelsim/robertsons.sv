module robertsons #(parameter N = 4) (
    input clk,
    input reset,    
    input [N-1:0] q, // multiplier
    input [N-1:0] m, // multiplicand
    output done,
    output [2*N-1:0] p // product
);

    typedef enum logic { ADD, SUB } op_state;
    op_state state;

    localparam COUNT = N; //length of loop
    logic done_t;
    logic [N-1:0] accumulator;
    logic [N-1:0] accumulator_sum;
    logic sign;

    logic [N-1:0] multiplier;
    logic [N-1:0] multiplicand;
    logic [2*N-1:0] product;

    logic [N-1:0] temp_buffer;

    logic [$clog2(COUNT):0] counter;

    logic sign_new;

    always_ff @ (posedge clk) begin
        if (!reset) begin
            multiplicand <= m;
            sign <= 'b0;
            product <= 'b0;
            done_t <= 'b0;
            counter <= 'b0;
        end else begin
            sign <= sign_new;
            product <= {sign_new, accumulator_sum, multiplier[N-1:1]};
            counter <= counter + 1;
            if (counter == COUNT - 1) begin
                done_t <= 'b1;
            end
        end
    end

    always_comb begin
        sign_new = sign;
        if (counter == 0) begin
            multiplier = q;
        end else begin
            multiplier = product[N-1:0];
        end

        accumulator = product[2*N-1:N];

        temp_buffer = multiplicand & {N{multiplier[0]}};
        if (counter < (N - 1)) begin
            accumulator_sum = accumulator + (temp_buffer);
            sign_new = (multiplicand[N-1] & multiplier[0]) | sign;
            state = ADD;
        end else begin
            accumulator_sum = accumulator - (temp_buffer);
            sign_new = multiplicand[N-1] ^ multiplier[0];
            state = SUB;
        end

        // Special case handling when multiplier is 0 and multiplicand is negative
        if ((q == 0 && m[N-1] == 1) || q[N-1] == 1 && m == 0) begin
            sign_new = 0;
        end
    end

    assign done = done_t;
    assign p = product;

endmodule
