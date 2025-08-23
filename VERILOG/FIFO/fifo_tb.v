//it contain directed testcase and random testcase with corner case

`timescale 1ns/1ps

module tb_fifo_sync;

  // Parameters
  parameter FIFO_DEPTH = 8;
  parameter DATA_WIDTH = 8;

  // Testbench signals
  reg clk;
  reg rst_n;
  reg cs;
  reg wr_en;
  reg rd_en;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire empty;
  wire full;

  // Instantiate DUT
  fifo_sync #(.FIFO_DEPTH(FIFO_DEPTH), .DATA_WIDTH(DATA_WIDTH)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .cs(cs),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty),
    .full(full)
  );

  // Clock generation
  always #5 clk = ~clk;  // 100MHz clock

  // Task to write into FIFO
  task fifo_write(input [DATA_WIDTH-1:0] din);
    begin
      @(posedge clk);
      cs <= 1;
      wr_en <= 1;
      rd_en <= 0;
      data_in <= din;
      $display($time, " write_data data_in = %0d", data_in);
      @(posedge clk);
      wr_en <= 0;
    end
  endtask

  // Task to read from FIFO
  task fifo_read;
    begin
      @(posedge clk);
      cs <= 1;
      wr_en <= 0;
      rd_en <= 1;
      @(posedge clk);
       $display($time, " read_data data_out = %0d", data_out);
      rd_en <= 0;
    end
  endtask

  // Test procedure
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    cs = 0;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;

    // Apply reset
    $display("==== Resetting FIFO ====");
    #20 rst_n = 1;

    // 1. Write one data then read it
    $display("==== Write then Read ====");
    fifo_write(8'hA5);
    fifo_read;
    $display("Data out = %h", data_out);

    // 2. Fill the FIFO completely
    $display("==== Filling FIFO ====");
    repeat (FIFO_DEPTH) fifo_write($random);
    $display("FIFO Full = %b", full);

    // 3. Try writing when FIFO is full
    $display("==== Writing when Full ====");
    fifo_write(8'h55);  // should be ignored

    // 4. Read all data back
    $display("==== Reading all FIFO contents ====");
    repeat (FIFO_DEPTH) fifo_read;
    $display("FIFO Empty = %b", empty);

    // 5. Try reading when FIFO is empty
    $display("==== Reading when Empty ====");
    fifo_read;  // should not give new data

    // 6. Write and Read simultaneously
    $display("==== Simultaneous Read/Write ====");
    fifo_write(8'h11);
    fifo_write(8'h22);
    @(posedge clk);
    wr_en <= 1;
    rd_en <= 1;
    data_in <= 8'h33;
    @(posedge clk);
    wr_en <= 0;
    rd_en <= 0;
    @(posedge clk);
    $display("Simultaneous R/W: Wrote %h, Read %h", data_in, data_out);

    // 7. Randomized test: mixed writes and reads
    $display("==== Random Stress Test ====");
    repeat (20) begin
      if ($random % 2) fifo_write($random);
      else fifo_read;
    end

    #50;
    $display("==== Test Completed ====");
    $finish;
  end

endmodule
