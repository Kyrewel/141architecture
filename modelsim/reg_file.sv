// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)(
  input[7:0] r1, r2, mem_data_out, alu_result,
  input immtoRegFlag, memToRegFlag, sc_out, 
  input      clk,
  input      wr_en,           // write enable
  input[pw-1:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			        rd_addrB,
  input wire [11:0] dat_mem_ctr,
                    accumulator_ctr,
                    alu_ctr,
  input wire reg_file_print,
  
  output logic [11:0] reg_file_ctr,
  output logic[7:0] datA_out, // read data
                    datB_out);
					
  logic [11:0] old_accumulator_ctr = -1;
  logic [11:0] old_dat_mem_ctr = -1;
  logic [11:0] old_alu_ctr = -1;
  logic [7:0] data_in;
  logic [7:0] core[2**pw];    // 2-dim array  8 wide  16 deep
  logic [7:0] old_core[2**pw]; // Array to store old values of core for comparison

  initial begin
    for (int i = 0; i < 2**pw; i++) begin
      old_core[i] = 'bx; // Initialize old_core values
    end
  end

// writes are sequential (clocked)
  always_comb begin
    if (old_accumulator_ctr !== accumulator_ctr) begin
      datA_out = core[rd_addrA];
      datB_out = core[rd_addrB];
      old_accumulator_ctr = accumulator_ctr;
      reg_file_ctr = accumulator_ctr;
    end
  end

  always_comb begin
    if (old_dat_mem_ctr !== dat_mem_ctr && old_alu_ctr !== alu_ctr) begin
      // Cases for what is saved
      if (immtoRegFlag) begin
        data_in = r1;
      end else if (memToRegFlag) begin
        data_in = mem_data_out;
      end else begin
        data_in = alu_result;
      end

      // Write operation
      if(wr_en) begin				   // anything but stores or no ops
        core[wr_addr] = data_in;
        if (reg_file_print) begin
          $display("RF: time=%t writing %d to reg %d", $time, data_in, wr_addr); 
          for (int j = 0; j < 2**pw; j++) begin
            $display("RF: core[%0d] = %d, %d, %b", j, $signed(core[j]), core[j], core[j]);
          end
        end
      end	
      old_dat_mem_ctr = dat_mem_ctr;
      old_alu_ctr = alu_ctr;

      // Overflow
      if ((sc_out === 'b0 || sc_out === 'b1) && r1 !== 15 && r2 !== 15) begin
        core[15] = sc_out;
      end
    end
  end
  // Debugging code to print the contents of the core register array

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