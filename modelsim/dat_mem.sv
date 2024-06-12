// 8-bit wide, 256-word (byte) deep memory array
module dat_mem (
  input[7:0] dat_in,
  input      clk,
  input      wr_en,	          // write enable
  input[7:0] addr,		      // address pointer
  input logic [11:0] reg_file_ctr,
  output logic [7:0] dat_out,
  output logic [11:0] dat_mem_ctr);

  logic[7:0] core[256];       // 2-dim array  8 wide  256 deep
  logic [11:0] oldRegFileCtr = -1;

// writes are sequential (clocked) -- occur on stores or pushes 
  always_comb begin
    if (oldRegFileCtr !== reg_file_ctr) begin
      dat_out = core[addr];
      if(wr_en) begin				  // wr_en usually = 0; = 1 	
        core[addr] = dat_in;
        $display("DM: time=%t writing %d to addr %d, Core value: %d", $time, dat_in, addr, core[addr]); 	
      end
      oldRegFileCtr = reg_file_ctr;
      dat_mem_ctr = reg_file_ctr;
    end

    // $monitor("Data Output: %d at time %t", dat_out, $time);
  end

endmodule

