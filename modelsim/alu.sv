// combinational -- no clock
module alu(
  input[3:0] ALUOp,         // ALU instructions
  input[7:0] inA, inB,	  // 8-bit wide data path
  input shiftcarry_in,            // carry in bit
  output logic[7:0] rslt,       // output result
  output logic shiftcarry_out,     // carry out bit
  output logic branchFlag
);

always_comb begin 
  rslt = 'b0;            
  shiftcarry_out = 'b0;
  branchFlag = 'b0;
  case(ALUOp)
    4'b0000: begin // bitwise AND
      rslt = inA & inB;
    end
	  4'b0001: begin // bitwise XOR
      rslt = inA ^ inB;
    end
	  4'b0010: begin// bitwise OR
      rslt = inA | inB;
    end
	  4'b0011: begin // logical left shift
      {shiftcarry_out, rslt} = {inA, shiftcarry_in};
    end
	  4'b0100: begin // logical right shift
      {rslt, shiftcarry_out} = {shiftcarry_in,inA};
    end
	  4'b0101: begin // logical add
      {shiftcarry_out, rslt} = inA + inB + shiftcarry_in;
    end
	  4'b0110: begin // logical subtract
      {shiftcarry_out, rslt} = inA - inB + shiftcarry_in;
    end
    4'b0111: begin // less than
      if(inA < inB)
        branchFlag = 1;
    end
    4'b1000: begin // greater than
      if(inA > inB)
        branchFlag = 1;
    end
    4'b1001: begin // equal to
      if (inA == inB)
        branchFlag = 1;
    end
    default:
      rslt = inA;
  endcase
end
   
endmodule