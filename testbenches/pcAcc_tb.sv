module pcAcc_tb;

  reg clk, reset, putEn, opEn, absjump_en;
  reg [7:0] value;
  reg [11:0] target;
  reg  regWriteFlag;
  reg  memWriteFlag;                     // from control to PC; relative jump enable
  reg  aluBranchFlag; 
  reg  controlBranchFlag; 
  reg  branchFlag;
  reg  memToRegFlag; 
  reg  immtoRegFlag;
  wire[8:0]   mach_code;          // machine code
  wire[7:0]   put_value;
  wire [7:0]  r0, r1, r2;
  wire [11:0] prog_ctr;
  wire r0_valid, r1_valid, r2_valid;
  wire [3:0]  ALUOp;
  wire [7:0]  alu_result;
  wire [7:0]  datA,datB;		  // from RegFile
  wire[7:0]   mem_data_out;





  // Instantiate the Accumulator
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

  // Instantiate the Program Counter
  PC #(.D(12)) pc(
    .reset(reset),
    .clk(clk),
    .absjump_en(absjump_en),
    .target(target),
    .prog_ctr(prog_ctr)
  );

  control ctl1(
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

  instr_ROM rom1(
    .mach_code(mach_code),
    .prog_ctr(prog_ctr)
  );

  alu alu1(
  .ALUOp(ALUOp),
  .inA(datA),
  .inB(datB),
  .shiftcarry_in(sc_in),   // input from sc register
  .rslt(alu_result),
  .shiftcarry_out(sc_out), // output to sc register 
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

  reg_file #(.pw(3)) rf1(
  .dat_in(reg_file_data_in),	   // loads, most ops
  .clk(clk),
  .wr_en(regWriteFlag),
  .rd_addrA(r1[3:0]),
  .rd_addrB(r2[3:0]),
  .wr_addr(r0[3:0]),      // in place operation
  .datA_out(datA),
  .datB_out(datB)
  ); 

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1;
    #10;
    reset = 0;

    #600;
    $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%t clk=%b putEn=%b opEn=%b value=%h r0=%h r1=%h r2=%h r0_valid=%b r1_valid=%b r2_valid=%b prog_ctr=%h",
             $time, clk, putEn, opEn, value, r0, r1, r2, r0_valid, r1_valid, r2_valid, prog_ctr);
  end

endmodule
