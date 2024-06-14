// control decoder
module control (
  input[8:0] instruction,
  input logic [12-1:0] instr_ROM_ctr,
  output logic branchFlag, memToRegFlag, memWriteFlag, 
                regWriteFlag, putEn, opEn, immtoRegFlag, ctr_print,
  output logic[4:0] ALUOp,
  output logic[7:0] value,
  output logic[12-1:0] control_ctr
);

logic [12-1:0] old_instr_ROM_ctr = -1;
logic itype;
logic[4:0] opcode;


always_comb begin
  if (old_instr_ROM_ctr !== instr_ROM_ctr) begin
    ALUOp         = 'b11111;
    immtoRegFlag  = 'b0;
    regWriteFlag  = 'b1;
    memToRegFlag  = 'b0;
    memWriteFlag  = 'b0;
    branchFlag    = 'b0;
    putEn       = 'b0;
    opEn        = 'b1;
    itype = instruction[0:0];
    opcode = instruction[5:1];
    value = instruction[8:1];
    case(itype)  
      'b0:  begin          // run type
              case (opcode)
                'b00000: begin     // load immediate
                          immtoRegFlag = 'b1;
                        end
                'b00001: begin     // load from memory
                          memToRegFlag = 'b1;
                        end
                'b00010: begin     //store to memory
                          memWriteFlag = 'b1;
                          regWriteFlag = 'b0;
                        end
                'b00011: begin     //add
                          ALUOp = 4'b00101;
                        end
                'b00100: begin     //sub
                          ALUOp = 4'b00110;
                        end
                'b00101: begin     //xor
                          ALUOp = 4'b00001;
                        end
                'b00110: begin     //or
                          ALUOp = 4'b00010;
                        end
                'b00111: begin     //and
                          ALUOp = 4'b00000;
                        end
                'b01000: begin     //jump
                          regWriteFlag = 'b0;
                          branchFlag = 1;
                        end
                'b01001: begin     //branch equal to
                          regWriteFlag = 'b0;
                          ALUOp = 4'b01001;
                        end
                'b01010: begin     //branch less than
                          regWriteFlag = 'b0;
                          ALUOp = 4'b00111;
                        end
                'b01011: begin     //branch greater than
                          regWriteFlag = 'b0;
                          ALUOp = 4'b01000;
                        end
                'b01100: begin     //left shift
                          ALUOp = 4'b00011;
                        end
                'b01101: begin     //right shift
                          ALUOp = 4'b00100;
                        end
                'b01110: begin // unsigned sub
                          ALUOp = 4'b01010;
                        end
                'b01111: begin // signed less than
                          regWriteFlag = 'b0;
                          ALUOp = 4'b01011;
                        end
                'b10000: begin // signed greater than
                          regWriteFlag = 'b0;
                          ALUOp = 4'b01100;
                        end
                'b10001: begin //unsigned addition
                          ALUOp = 4'b01101;
                        end
                default: begin
                  ALUOp = 4'b11111;
                end                     
              endcase      
            end
      'b1:  begin         // put type
              putEn = 'b1;
              opEn = 'b0;
              regWriteFlag = 'b0;
            end
      default: begin
        putEn = 'b0;
        opEn = 'b0;
        regWriteFlag = 'b0;
      end
    endcase
    // $display("CTR: opcode: %b , aluop: %b", opcode, ALUOp);
    old_instr_ROM_ctr = instr_ROM_ctr;
    control_ctr = instr_ROM_ctr;

  end
end


endmodule