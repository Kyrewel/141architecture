// control decoder
module control(
  input[8:0] instruction,         
  output logic branchFlag, memToRegFlag, memWriteFlag, 
                regWriteFlag, putFlag, immtoRegFlag,
  output logic[3:0] ALUOp
);

logic itype;
logic[3:0] opcode;

always_comb begin
  // defaults
  ALUOp         = 'b0111;
  immtoRegFlag  = 'b0;
  regWriteFlag  = 'b1;
  memToRegFlag  = 'b0;
  memWriteFlag  = 'b0;
  branchFlag    = 'b0;
  putFlag       = 'b0;

  itype = instruction[0:0];
  opcode = instruction[4:1];

  case(itype)  
    'b0:  begin          // run type
            case (opcode)
              'b0000: begin     // load immediate
                        immtoRegFlag = 'b1;
                      end
              'b0001: begin     // load from memory
                        memToRegFlag = 'b1;
                      end
              'b0010: begin     //store to memory
                        memWriteFlag = 'b1;
                        regWriteFlag = 'b0;
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
                        regWriteFlag = 'b0;
                        branchFlag = 'b1;
                      end
              'b1001: begin     //branch equal to
                        regWriteFlag = 'b0;
                        ALUOp = 4'b1010;
                      end
              'b1010: begin     //branch less than
                        regWriteFlag = 'b0;
                        ALUOp = 4'b1000;
                      end
              'b1011: begin     //branch greater than
                        regWriteFlag = 'b0;
                        ALUOp = 4'b1001;
                      end
              'b1100: begin     //left shift
                        ALUOp = 4'b0011;
                      end
              'b1101: begin     //right shift
                        ALUOp = 4'b0100;
                      end
              default: begin
                ALUOp = 4'b0111;
              end                     
            endcase      
          end
    'b1:  begin         // put type
            putFlag = 'b1;
            regWriteFlag = 'b0;
          end
  endcase
end
endmodule