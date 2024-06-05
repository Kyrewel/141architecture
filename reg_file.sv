// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)(
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable
  input[pw:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			  rd_addrB,
  output logic[7:0] datA_out, // read data
                    datB_out);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];

// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    if(wr_en) begin				   // anything but stores or no ops
      core[wr_addr] <= dat_in;
	end
  end
  // Debugging code to print the contents of the core register array
  always_ff @(posedge clk) begin
    if (wr_en) begin
      $display("Write operation: Writing %h to address %h", dat_in, wr_addr);
    end
    // Print the entire core register array for debugging
    $display("Core Register Contents:");
    for (int i = 0; i < 2**pw; i++) begin
      $display("core[%0d] = %h", i, core[i]);
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