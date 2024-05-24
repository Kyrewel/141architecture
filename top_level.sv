// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 4;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire  regWriteFlag;
  wire  memWriteFlag;                     // from control to PC; relative jump enable
  wire  aluBranchFlag; 
  wire  controlBranchFlag; 
  wire  branchFlag
  wire  memToRegFlag; 
  wire  putFlag;
  wire  immtoRegFlag;
  wire  accumulatorDone;
  wire  storeDone;
  wire  writeDone;
  wire  nextInstructionFlag;
  wire[7:0]   r0, r1, r2;
  wire[7:0]   wr_reg, rd_regA, rd_regB;
  wire[7:0]   mem_data_out;
  wire[7:0]   alu_result;

  wire[7:0]   putValue;
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, 
			  rslt,               // alu output
              immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  pari,
        zero,
		sc_clr,
		sc_en,
        MemWrite,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_adrB;    // address pointers to reg_file

assign nextInstructionFlag = storeDone || accumulatorDone || writeDone;
assign branchFlag = controlBranchFlag || aluBranchFlag;
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (
  .reset()            ,
  .clk(clk)              ,
  .nextFlag(nextInstructionFlag),
  .absjump_en (branchFlag),
	.target(target)           ,
	.prog_ctr(prog_ctr)          );

// lookup table to facilitate jumps/branches
PC_LUT #(.D(D))
  pl1 (
  .addr  (r2),
  .target(target));   

// contains machine code
  instr_ROM ir1(
  .prog_ctr(prog_ctr),
  .mach_code(mach_code)
  );

// control decoder
  Control ctl1(
  .instruction(mach_code),
  .branchFlag(controlBranchFlag), 
  .memWriteFlag(memWriteFlag), 
  .regWriteFlag(regWriteFlag),     
  .memToRegFlag(memToRegFlag),
  .immtoRegFlag(immtoRegFlag),
  .putFlag(putFlag),
  .ALUOp(alu_cmd)
  );

  assign putValue = mach_code[7:0];

  Accumulator acum1(
  .clk(clk),
  .putFlag(putFlag),
  .value(putValue),
  .r0(r0),
  .r1(r1),
  .r2(r2),
  .done(accumulatorDone),
  )

  assign wr_reg  = r0[7:4];
  assign rd_regA = r1[7:4];
  assign rd_regB = r2[7:4];

  if (immtoRegFlag) begin
    assign reg_file_data_in = r1;
  end else if (memToRegFlag) begin
    assign reg_file_data_in = mem_data_out;
  end else begin
    assign reg_file_data_in = alu_result;
  end

  reg_file #(.pw(3)) rf1(
  .dat_in(reg_file_data_in),	   // loads, most ops
  .clk(clk),
  .wr_en(regWriteFlag),
  .rd_addrA(rd_regA),
  .rd_addrB(rd_regB),
  .wr_addr(rd_addrB),      // in place operation
  .datA_out(datA),
  .datB_out(datB),
  .done(writeDone)
  ); 

  alu alu1(
  .alu_cmd(alu_cmd),
  .inA(datA),
  .inB(datB),
  .shiftcarry_in(sc),   // output from sc register
  .rslt(alu_result),
  .shiftcarry_out(sc_o) // input to sc register 
  .branchFlag(aluBranchFlag)
  );

  assign data_memory_addr = memWriteFlag ? r1 : r0;

  dat_mem dm1(
  .dat_in(datA)  ,  // from reg_file
  .clk(clk)           ,
	.wr_en  (memWriteFlag), // stores
	.addr   (data_memory_addr),
  .dat_out(mem_data_out));

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule