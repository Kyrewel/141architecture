// combinational -- no clock
module alu(
  input[4:0] ALUOp,         // ALU instructions
  input [7:0] inA, inB,	  // 8-bit wide data path
  input shiftcarry_in,            // carry in bit
  // input clk,
  input [12-1:0] reg_file_ctr,
  output logic [7:0] rslt,       // output result
  output logic shiftcarry_out,     // carry out bit
  output logic branchFlag,
  output logic [12-1:0] alu_ctr
);

logic reset = 0;
logic [3:0] a, b;
logic [7:0] product;

logic [12-1:0] old_reg_file_ctr = -1;

logic [7:0] tempAdd;

always_comb begin 
  if (old_reg_file_ctr != reg_file_ctr) begin
    rslt = 'b0;            
    shiftcarry_out = 'bx;
    branchFlag = 'b0;
    case(ALUOp)
      5'b00000: begin // bitwise AND
        rslt = inA & inB;
      end
      5'b00001: begin // bitwise XOR
        rslt = inA ^ inB;
      end
      5'b00010: begin// bitwise OR
        rslt = inA | inB;
      end
      5'b00011: begin // logical left shift
        {shiftcarry_out, rslt} = inA << 1;
        rslt[0] = shiftcarry_in; // Fill LSB with carry in
      end
      5'b00100: begin // logical right shift
        {shiftcarry_out, rslt} = inA >> 1;
        rslt[7] = 0; // Clear MSB to ensure it's a logical shift
      end
      5'b00101: begin  // signed add
        // Check for overflow, then do add operation
        tempAdd = inA + inB;
        if (inA[7] == 0 && inB[7] == 0) begin // both positive
          if (tempAdd[7] == 1) begin
            // Positive overflow
            shiftcarry_out = 1;
            tempAdd[7] = 0; // Correct overflow
          end else begin
            shiftcarry_out = 0;
          end
        end else if (inA[7] == 1 && inB[7] == 1) begin // both negative
          if (tempAdd[7] == 0) begin
            // Negative overflow
            shiftcarry_out = 1;
            tempAdd[7] = 1; // Correct overflow
          end else begin
            shiftcarry_out = 0;
          end
        end else begin // one positive, one negative
          // No overflow possible
          shiftcarry_out = 0;
        end
        rslt = tempAdd;
      end
      5'b00110: begin // signed subtract
      // Check for overflow, then do subtract operation
      tempAdd = inA - inB;
      if (inA[7] == 0 && inB[7] == 1) begin // positive - negative
          if (tempAdd[7] == 1) begin
              // Positive overflow
              shiftcarry_out = 1;
              tempAdd[7] = 0; // Correct overflow
          end else begin
              shiftcarry_out = 0;
          end
      end else if (inA[7] == 1 && inB[7] == 0) begin // negative - positive
          if (tempAdd[7] == 0) begin
              // Negative overflow
              shiftcarry_out = 1;
              tempAdd[7] = 1; // Correct overflow
          end else begin
              shiftcarry_out = 0;
          end
      end else begin // both positive or both negative
          // No overflow possible
            shiftcarry_out = 0;
        end
        rslt = tempAdd;
      end
      5'b00111: begin // less than
        if(inA < inB)
          branchFlag = 1;
      end
      5'b01000: begin // greater than
        if(inA > inB)
          branchFlag = 1;
      end
      5'b01001: begin // equal to
        if (inA == inB)
          branchFlag = 1;
      end
      5'b01010: begin // subtract unsigned
        {shiftcarry_out, rslt} = inA - inB + shiftcarry_in;
      end
      5'b01011: begin // signed branch if less than
        if ($signed(inA) < $signed(inB))
          branchFlag = 1;
      end
      5'b01100: begin // signed branch if greater than
        if ($signed(inA) > $signed(inB))
          branchFlag = 1;
      end
      5'b01101: begin // add unsigned
        {shiftcarry_out, rslt} = inA + inB + shiftcarry_in;
      end
        
      default:
        rslt = inA;
    endcase
  end
  old_reg_file_ctr = reg_file_ctr;
  alu_ctr = reg_file_ctr;

  // $monitor("ALU Result: %b", rslt); // Monitor for rslt added
  // $monitor("Current Opcode: %b, Current inA: %d, Current inB: %d", ALUOp, inA, inB);  
end
   
endmodule