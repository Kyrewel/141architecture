// 8-bit wide, 256-word (byte) deep memory array
module dat_mem (
  input[7:0] dat_in,
  input      clk,
  input      wr_en,	          // write enable
  input[7:0] addr,		      // address pointer
  input wire [11:0] prog_ctr,
  output logic[7:0] dat_out);

  logic[7:0] core[256];       // 2-dim array  8 wide  256 deep
  logic [11:0] oldPC = -1;

// reads are combinational; no enable or clock required
  assign dat_out = core[addr];

// writes are sequential (clocked) -- occur on stores or pushes 
  always_ff @(posedge clk) begin
    if(wr_en && oldPC !== prog_ctr) begin				  // wr_en usually = 0; = 1 
      $info("DM: time=%t writing %d to addr %h", $time, dat_in, addr); 		
      core[addr] <= dat_in;
      oldPC <= prog_ctr;
    end
  end

endmodule

