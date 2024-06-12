// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instr_ROM #(parameter D=12)(
  input       [D-1:0] prog_ctr,    // prog_ctr	  address pointer
  output logic [8:0] mach_code,
  output logic [D-1:0] instr_ROM_ctr,
  output logic program_done);

  logic [D-1:0]old_prog_ctr = -1;
  logic[8:0] core[2**D];
  initial							    // load the program
    $readmemb("mach_code.txt",core);

  always_comb begin
    if (prog_ctr != old_prog_ctr) begin
      mach_code = core[prog_ctr];
      if (mach_code === 9'bxxxxxxxx && prog_ctr >= 1) begin
        program_done = 'b1;
      end else begin
        program_done = 'b0;
      end

      $monitor("Instruction: %d", mach_code);

      old_prog_ctr = prog_ctr;
      instr_ROM_ctr = old_prog_ctr;
      
    end
  end


endmodule
// use program counter only
// when prog counter updates --> reg file updates and dat mem updates
// dat mem updates first, reg file updates second

/*
sample mach_code.txt:

001111110		 // ADD r0 r1 r0
001100110
001111010
111011110
101111110
001101110
001000010
111011110
*/