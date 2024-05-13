// combinational -- no clock
module alu(
  input[3:0] alu_cmd,         // ALU instructions
  input[7:0] inA, inB,	  // 8-bit wide data path
  input shiftcarry_in,            // carry in bit
  output logic[7:0] rslt,       // output result
  output logic shiftcarry_out     // carry out bit
);

always_comb begin 
  rslt = 'b0;            
  case(alu_command)
    4'b0000: // bitwise AND
      rslt = inA & inB
	  4'b0001: // bitwise XOR
      rslt = inA ^ inB
	  4'b0010: // bitwise OR
      rslt = inA | inB
	  4'b0011: // logical left shift
      {shiftcarry_out, rslt} = {inA, shiftcarry_in};
	  4'b0100: // logical right shift
      {rslt, shiftcarry_out} = {shiftcarry_in,inA};
	  4'b0101: // logical add
      {shiftcarry_out, rslt} = inA + inB + shiftcarry_in
	  4'b0110: // logical subtract
      {shiftcarry_out, rslt} = inA - inB + shiftcarry_in
    4'b0111: // pass A
      rslt = inA
  endcase
end
   
endmodule