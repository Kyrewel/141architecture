`timescale 1ns / 1ps

module reg_file_tb;

  // Parameters
  parameter pw = 4; // pointer width for address

  // Inputs
  reg [7:0] dat_in;
  reg clk;
  reg wr_en;
  reg [pw:0] wr_addr, rd_addrA, rd_addrB;

  // Outputs
  wire done;
  wire [7:0] datA_out, datB_out;

  // Instantiate the reg_file module
  reg_file #(.pw(pw)) uut (
    .dat_in(dat_in),
    .clk(clk),
    .wr_en(wr_en),
    .wr_addr(wr_addr),
    .rd_addrA(rd_addrA),
    .rd_addrB(rd_addrB),
    .done(done),
    .datA_out(datA_out),
    .datB_out(datB_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize inputs
    dat_in = 0;
    wr_en = 0;
    wr_addr = 0;
    rd_addrA = 0;
    rd_addrB = 0;

    // Test Case 1: Write and Read from Register File
    #10;
    dat_in = 8'hAA; // Test data
    wr_addr = 4'h3; // Test write address
    rd_addrA = 4'h3; // Test read address for datA_out
    wr_en = 1;      // Enable write
    #10;
    wr_en = 0;      // Disable write
    #10;
    $display("Test Write: Address %h, Data Written %h", wr_addr, dat_in);
    #10;
    $display("Test Read A: Address %h, Data Read %h", rd_addrA, datA_out);
    if (datA_out == dat_in) begin
      $display("Test Case 1 Passed");
    end else begin
      $display("Test Case 1 Failed");
    end

    // Test Case 2: Check done signal
    #10;
    dat_in = 8'hFF; // New test data
    wr_addr = 4'h8; // New test address
    wr_en = 1;      // Enable write
    #10;
    if (done) begin
      $display("Test Case 2 Passed: Done signal asserted correctly");
    end else begin
      $display("Test Case 2 Failed: Done signal not asserted");
    end
    wr_en = 0;      // Disable write

    // Finish the simulation
    #20;
    $finish;
  end

endmodule
