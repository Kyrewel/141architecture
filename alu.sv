// combinational -- no clock
module alu(
  input[3:0] alu_command,         // ALU instructions
  input[7:0] input_A, input_B,	  // 8-bit wide data path
  input shiftcarry_in,            // carry in bit
  output logic[7:0] result,       // output result
  output logic shiftcarry_out     // carry out bit
);

always_comb begin 
  rslt = 'b0;            
  case(alu_command)
    4'b0000: // bitwise AND
      result = input_A & input_B
	  4'b0001: // bitwise XOR
      result = input_A ^ input_B
	  4'b0010: // bitwise OR
      result = input_A | input_B
	  4'b0011: // logical left shift
      {shiftcarry_out, result} = {input_A, shiftcarry_in};
	  4'b0100: // logical right shift
      {result, shiftcarry_out} = {shiftcarry_in,input_A};
	  4'b0101: // logical add
      {shiftcarry_out, reslt} = input_A + input_B + shiftcarry_in
	  4'b0110: // logical subtract
      {shiftcarry_out, reslt} = input_A - input_B + shiftcarry_in
    4'b0111: // pass A
      result = input_A
  endcase
end
   
endmodule