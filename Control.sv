// control decoder
module Control(
  input[8:0] instruction,         
  output logic Branch, 
     MemtoReg, MemWrite, RegWrite, IsPutType, ImmtoReg
  output logic[3:0] ALUOp
);

always_comb begin
  // defaults
  IsPutType = 'b0;
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    = 'b0111;
  ImmtoReg =  'b0;
  logic itype = instruction[0:0];
  logic opcode = instruction[4:1];

  case(itype)  
    'b0:  begin					// run type
            case (opcode)
              'b0000: begin     // load immediate
                        ImmtoReg = 'b1;
                      end
              'b0001: begin     // load from memory
                        MemtoReg = 'b1;
                      end
              'b0010: begin     //store to memory
                        MemWrite = 'b1;
                        RegWrite = 'b0;
                      end
              'b0011: begin     //add
                        ALUOp = 4'b0101;
                      end
              'b0100: begin     //sub
                        ALUOp = 4'b0110;
                      end
              'b0101: begin     //xor
                        ALUOp = 4'b0001;
                      end
              'b0110: begin     //or
                        ALUOp = 4'b0010;
                      end
              'b0111: begin     //and
                        ALUOp = 4'b0000;
                      end
              'b1000: begin     //jump
                        RegWrite = 'b0;
                        Branch = 'b1;
                      end
              'b1001: begin     //branch equal to
                        RegWrite = 'b0;
                        Branch = 'b1;
                      end
              'b1010: begin     //branch less than
                        RegWrite = 'b0;
                        Branch = 'b1;
                      end
              'b1011: begin     //branch greater than
                        RegWrite = 'b0;
                        Branch = 'b1;
                      end
              'b1100: begin     //left shift
                        ALUOp = 4'b0011;
                      end
              'b1101: begin     //right shift
                        ALUOp = 4'b0100;
                      end                     
            endcase      
                  
          end
    'b1:  begin         // put type
            IsPutType = 'b1;
            RegWrite = 'b0;
          end
  // ...
  endcase

end
	
endmodule