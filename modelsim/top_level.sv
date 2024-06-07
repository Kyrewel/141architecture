module top_level(
  input        clk, reset, req, 
  output logic done);

  //constants
  reg program_counter_size = 12; //bits
  reg register_size = 4; //bits
  reg address_size = 8; //bits
  //flags
  reg regWriteFlag, 
      memWriteFlag, 
      aluBranchFlag, 
      controlBranchFlag, 
      memToRegFlag,
      immtoRegFlag,
      putEn,
      opEn,
      program_done;    
  //machine code
  wire[8:0]   mach_code;
  //value to put into accumulator
  wire[7:0]   put_value;
  //accumulator registers and valid bits
  wire [7:0]  r0, r1, r2;
  wire r0_valid, r1_valid, r2_valid;
  //program counter
  wire [11:0] prog_ctr;
  //ALU operation and result
  wire [3:0]  ALUOp;
  wire [7:0]  alu_result;
  //register file output
  wire [7:0]  datA,datB;
  //data memory output
  wire [7:0]   mem_data_out;

// program counter module
  PC pc(
    .reset(reset),
    .clk(clk),
    .branchFlag(aluBranchFlag || controlBranchFlag),
    .target(target),
    .prog_ctr(prog_ctr)
  );

// program look up module
  PC_LUT pl1 (
    .tag  (r2),
    .target(target)
  );   

// accumulator module
  Accumulator acc(
    .clk(clk),
    .putEn(putEn),
    .opEn(opEn),
    .value(put_value),
    .r0(r0),
    .r1(r1),
    .r2(r2),
    .r0_valid(r0_valid),
    .r1_valid(r1_valid),
    .r2_valid(r2_valid),
    .prog_ctr(prog_ctr)
  );

// control module
  control ctl(
    .instruction(mach_code),
    .branchFlag(controlBranchFlag), 
    .memWriteFlag(memWriteFlag), 
    .regWriteFlag(regWriteFlag),     
    .memToRegFlag(memToRegFlag),
    .immtoRegFlag(immtoRegFlag),
    .putEn(putEn),
    .opEn(opEn),
    .ALUOp(ALUOp),
    .value(put_value)
  );

// instruction memory module
  instr_ROM rom(
    .mach_code(mach_code),
    .prog_ctr(prog_ctr),
    .program_done(program_done)
  );

// arithimetic logic unit module
  alu alu(
  .ALUOp(ALUOp),
  .inA(datA),
  .inB(datB),
  .shiftcarry_in(sc_in), 
  .rslt(alu_result),
  .shiftcarry_out(sc_out), 
  .branchFlag(aluBranchFlag)
  );

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

// register file module
  reg_file rf(
    .dat_in(reg_file_data_in),
    .clk(clk),
    .wr_en(regWriteFlag),
    .rd_addrA(r1[3:0]),
    .rd_addrB(r2[3:0]),
    .wr_addr(r0[3:0]),
    .datA_out(datA),
    .datB_out(datB),
    .prog_ctr(prog_ctr)
  ); 

  dat_mem dm (
    .dat_in(datA),
    .clk(clk),
    .wr_en(wr_en),
    .addr(memWriteFlag ? r1 : r0),
    .done(done),
    .prog_ctr(prog_ctr),
    .dat_out(dat_out)
  );

  assign done = program_done;

  always_ff @(posedge clk) begin
    $info("Time: %0t | regWriteFlag: %b | memWriteFlag: %b | aluBranchFlag: %b | controlBranchFlag: %b | absjump_en: %b | memToRegFlag: %b | immtoRegFlag: %b | putEn: %b | opEn: %b | program_done: %b",
             $time, regWriteFlag, memWriteFlag, aluBranchFlag, controlBranchFlag, absjump_en, memToRegFlag, immtoRegFlag, putEn, opEn, program_done);
  end
endmodule