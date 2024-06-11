// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)(
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable
  input[pw-1:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			  rd_addrB,
  input wire [11:0] prog_ctr,
  output logic[7:0] datA_out, // read data
                    datB_out);
					
  logic [11:0] oldPC = -1;

  logic [7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];

// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    if(wr_en && oldPC !== prog_ctr) begin				   // anything but stores or no ops
      $info("RF: time=%t writing %d to reg %d", $time, dat_in, wr_addr); 
      core[wr_addr] <= dat_in;
	    oldPC <= prog_ctr;
	  end	
  end
  // Debugging code to print the contents of the core register array
  always_ff @(posedge clk) begin
    $info("---------- RF CORE ----------");
    for (int i = 0; i < 2**pw; i++) begin
      $display("RF: core[%0d] = %d", i, core[i]);
    end
end
  

endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/