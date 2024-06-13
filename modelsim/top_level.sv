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
  logic [8:0]   mach_code;
  //value to put into accumulator
  logic [7:0]   put_value;
  //accumulator registers and valid bits
  logic [7:0]  r0, r1, r2;
  //program counter
  wire [11:0] prog_ctr,
              instr_ROM_ctr,
              alu_ctr,
              accumulator_ctr,
              reg_file_ctr,
              dat_mem_ctr,
              control_ctr;
  //ALU operation and result
  wire [3:0]  ALUOp;
  wire [7:0]  alu_result;
  //register file output
  wire [7:0]  datA,datB;
  //data memory output
  wire [7:0]   mem_data_out;
  //target
  wire [11:0]   target;

  wire sc_in = 0;
  wire sc_out;

  reg accum_print = 1;
  reg reg_file_print = 1;
  reg dat_mem_print = 1;
  reg top_level_print = 1;
  reg pc_print = 1;
  reg ctr_print = 1;


// program counter module
  PC pc(
    .reset(reset),
    .clk(clk),
    .branchFlag(aluBranchFlag === 1 || controlBranchFlag === 1),
    .target(target),
    .prog_ctr(prog_ctr),
    .pc_print(pc_print)
  );

// program look up module
  PC_LUT pl1 (
    .tag  (r0),
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
    .accum_print(accum_print),
    
    .control_ctr(control_ctr),
    .accumulator_ctr(accumulator_ctr)
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
    .value(put_value),
    .ctr_print(ctr_print),

    .instr_ROM_ctr(instr_ROM_ctr),
    .control_ctr(control_ctr)
  );

// instruction memory module
  instr_ROM rom(
    .mach_code(mach_code),
    .program_done(program_done),

    .prog_ctr(prog_ctr),
    .instr_ROM_ctr(instr_ROM_ctr)
  );

// arithimetic logic unit module
  alu alu(
  .ALUOp(ALUOp),
  .inA(datA),
  .inB(datB),
  .shiftcarry_in(sc_in), 
  .rslt(alu_result),
  .shiftcarry_out(sc_out), 
  .branchFlag(aluBranchFlag),
  
  .reg_file_ctr(reg_file_ctr),
  .alu_ctr(alu_ctr)
  );
  

// register file module
  reg_file rf(
    .clk(clk),
    .wr_en(regWriteFlag),
    .rd_addrA(r1[3:0]),
    .rd_addrB(r2[3:0]),
    .wr_addr(r0[3:0]),
    .datA_out(datA),
    .datB_out(datB),
    .immtoRegFlag(immtoRegFlag),
    .r1(r1),
    .memToRegFlag(memToRegFlag),
    .mem_data_out(mem_data_out),
    .alu_result(alu_result),
    .sc_out(sc_out),
    .r2(r2),
    .reg_file_print(reg_file_print),
    
    .dat_mem_ctr(dat_mem_ctr),
    .accumulator_ctr(accumulator_ctr),
    .alu_ctr(alu_ctr),
    .reg_file_ctr(reg_file_ctr)
  ); 

  dat_mem dm (
    .dat_in(datB),
    .clk(clk),
    .wr_en(memWriteFlag),
    .addr(datA),
    .dat_out(mem_data_out),
    .dat_mem_print(dat_mem_print),
    
    .reg_file_ctr(reg_file_ctr),
    .dat_mem_ctr(dat_mem_ctr)
  );

  assign done = program_done;
  
  always_comb begin
    if (done) begin
      $display("Register Memory State at Completion:");
      for (int j = 0; j < 2**4; j++) begin
        $display("RF: core[%0d] = %d", j, $signed(rf.core[j]));
      end
    end
  end

  always_comb begin
    if (top_level_print) begin
      $monitor("Time: %0t | regWriteFlag: %b | memWriteFlag: %b | aluBranchFlag: %b | controlBranchFlag: %b | branchFlag: %b | memToRegFlag: %b | immtoRegFlag: %b | putEn: %b | opEn: %b | program_done: %b",
             $time, regWriteFlag, memWriteFlag, aluBranchFlag, controlBranchFlag, aluBranchFlag || controlBranchFlag, memToRegFlag, immtoRegFlag, putEn, opEn, program_done);
    end
  end
endmodule