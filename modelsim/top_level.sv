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
  wire  branchFlag;
  wire  memToRegFlag; 
  wire  putFlag;
  wire  immtoRegFlag;
  wire  accumulatorDone;
  wire  storeDone;
  wire  writeDone;
  wire  nextInstructionFlag;
  wire[7:0]   r0, r1, r2;
  wire[3:0]   wr_reg, rd_regA, rd_regB;
  wire[7:0]   mem_data_out;
  wire[7:0]   alu_result;
  wire[7:0]   data_memory_addr;

  wire[7:0]   putValue;
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, 
			  rslt,               // alu output
              immed;
  logic sc_out,   				  // shift/carry out from/to ALU
      sc_in,           // shift/carry in to ALU
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
  wire[2:0] rd_addrA, rd_addrB;    // address pointers to reg_file\
  logic r0_val, r1_val, r2_val;

assign nextInstructionFlag = storeDone || accumulatorDone || writeDone;
assign branchFlag = controlBranchFlag || aluBranchFlag;
// fetch subassembly
  PC pc1 (				  // D sets program counter width
  .reset(reset)            ,
  .clk(clk)              ,
  .nextFlag(nextInstructionFlag),
  .absjump_en (branchFlag),
	.target(target)           ,
	.prog_ctr(prog_ctr)          
  );

  $info("PC_LUT initialization");
// lookup table to facilitate jumps/branches
  PC_LUT pl1 (
  .tag  (r2),
  .target(target));   
  $info("Initializing instruction ROM");
  // contains machine code
  instr_ROM ir1(
  .prog_ctr(prog_ctr),
  .mach_code(mach_code)
  );

  $info("Initializing control module");
  // control decoder
  control ctl1(
  .instruction(mach_code),
  .branchFlag(controlBranchFlag), 
  .memWriteFlag(memWriteFlag), 
  .regWriteFlag(regWriteFlag),     
  .memToRegFlag(memToRegFlag),
  .immtoRegFlag(immtoRegFlag),
  .putFlag(putFlag),
  .ALUOp(alu_cmd)
  );

  assign putValue = mach_code[8:1];

  assign r0_val = 0;    // Validity flag for r0
  assign r1_val = 0;    // Validity flag for r1
  assign r2_val = 0;    // Validity flag for r2

  $info("Initializing Accumulator");
  Accumulator acum1(
  .clk(clk),
  .putFlag(putFlag),
  .value(putValue),
  .r0(r0),
  .r1(r1),
  .r2(r2),
  .r0_valid(r0_val),
  .r1_valid(r1_val),
  .r2_valid(r2_val),
  .done(accumulatorDone)
  );

  assign wr_reg  = r0[3:0];
  assign rd_regA = r1[3:0];
  assign rd_regB = r2[3:0];

  logic[7:0] reg_file_data_in; // Changed from wire to logic to allow procedural assignments
  always_comb begin
    if (immtoRegFlag) begin
      reg_file_data_in = r1;
    end else if (memToRegFlag) begin
      reg_file_data_in = mem_data_out;
    end else begin
      reg_file_data_in = alu_result;
    end
  end

  $info("Initializing Register File");
  reg_file #(.pw(3)) rf1(
  .dat_in(reg_file_data_in),	   // loads, most ops
  .clk(clk),
  .wr_en(regWriteFlag),
  .rd_addrA(rd_regA),
  .rd_addrB(rd_regB),
  .wr_addr(wr_reg),      // in place operation
  .datA_out(datA),
  .datB_out(datB),
  .done(writeDone)
  ); 

  $info("Initializing ALU");
  alu alu1(
  .alu_cmd(alu_cmd),
  .inA(datA),
  .inB(datB),
  .shiftcarry_in(sc_in),   // input from sc register
  .rslt(alu_result),
  .shiftcarry_out(sc_out), // output to sc register 
  .branchFlag(aluBranchFlag)
  );

  assign data_memory_addr = memWriteFlag ? r1 : r0;

  $info("Initializing Data Memory");
  dat_mem dm1(
  .dat_in(datA)  ,  // from reg_file
  .clk(clk)           ,
	.wr_en  (memWriteFlag), // stores
	.addr   (data_memory_addr),
  .dat_out(mem_data_out),
  .done(storeDone));

// registered flags from ALU
  
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_in;
  end

  always_ff @(posedge clk) begin
    $info("Time: %0t | regWriteFlag: %b | memWriteFlag: %b | aluBranchFlag: %b | controlBranchFlag: %b | branchFlag: %b | memToRegFlag: %b | putFlag: %b | immtoRegFlag: %b | accumulatorDone: %b | storeDone: %b | writeDone: %b | nextInstructionFlag: %b | mach_code: %b", 
      $time, regWriteFlag, memWriteFlag, aluBranchFlag, controlBranchFlag, branchFlag, memToRegFlag, putFlag, immtoRegFlag, accumulatorDone, storeDone, writeDone, nextInstructionFlag, mach_code);
  end

  assign done = mach_code === 9'bxxxxxxxx;

endmodule