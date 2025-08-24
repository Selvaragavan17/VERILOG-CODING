//desig code

module fifo_sync
    // Parameters section
    #( parameter FIFO_DEPTH = 8,
	   parameter DATA_WIDTH = 8) 
    // Ports section   
	(input clk, 
     input rst_n,
     input cs,     // chip select	 
     input wr_en, 
     input rd_en, 
     input [DATA_WIDTH-1:0] data_in, 
     output reg [DATA_WIDTH-1:0] data_out, 
	 output empty,
	 output full); 

  // log2(FIFO_DEPTH) = address width
  localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH); 
	
  // Declare memory array (FIFO storage)
  reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1]; 
	
  // Write/Read pointers (1 extra MSB bit for full/empty detection)
  reg [FIFO_DEPTH_LOG:0] write_pointer;
  reg [FIFO_DEPTH_LOG:0] read_pointer;

  // -------------------
  // WRITE LOGIC
  // -------------------
  always @(posedge clk or negedge rst_n) begin
      if(!rst_n) // reset active low
          write_pointer <= 0;
      else if (cs && wr_en && !full) begin
          fifo[write_pointer[FIFO_DEPTH_LOG-1:0]] <= data_in;
          write_pointer <= write_pointer + 1'b1;
      end
  end
  
  // -------------------
  // READ LOGIC
  // -------------------
  always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
          read_pointer <= 0;
      else if (cs && rd_en && !empty) begin
          data_out <= fifo[read_pointer[FIFO_DEPTH_LOG-1:0]];
          read_pointer <= read_pointer + 1'b1;
      end
  end
	
  // -------------------
  // STATUS FLAGS
  // -------------------
  assign empty = (read_pointer == write_pointer);
  assign full  = (read_pointer == {~write_pointer[FIFO_DEPTH_LOG],
                                   write_pointer[FIFO_DEPTH_LOG-1:0]});

endmodule

//testbech 

// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_fifo_sync;

  // Parameters
  localparam FIFO_DEPTH = 8;
  localparam DATA_WIDTH = 8;

  // DUT signals
  reg clk, rst_n, cs, wr_en, rd_en;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire empty, full;

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
  initial clk = 0;
  always #5 clk = ~clk;

  // --------------------
  // Helper Tasks
  // --------------------
  task reset_dut;
    begin
      $display("==== Reset DUT ====");
      rst_n = 0; cs = 1; wr_en = 0; rd_en = 0; data_in = 0;
      repeat(2) @(posedge clk);
      rst_n = 1;
      @(posedge clk);
    end
  endtask

  task fifo_write(input [DATA_WIDTH-1:0] din);
    begin
      @(posedge clk);
      wr_en <= 1; rd_en <= 0; data_in <= din;
      @(posedge clk);
      wr_en <= 0;
      $display($time, " Write data_in = %h", din);
    end
  endtask

  task fifo_read;
    begin
      @(posedge clk);
      wr_en <= 0; rd_en <= 1;
      @(posedge clk);
      rd_en <= 0;
      $display($time, " Read data_out = %h", data_out);
    end
  endtask

  // --------------------
  // Test Scenarios
  // --------------------

  // 1. Reset behavior
  task test_reset;
    begin
      reset_dut();
      if (empty && !full)
        $display("PASS: Reset -> FIFO empty as expected.");
      else
        $display("FAIL: Reset -> FIFO not empty!");
    end
  endtask

  // 2. Single write/read
  task test_single_write_read;
    begin
      $display("==== Single Write/Read ====");
      fifo_write(8'hA5);
      fifo_read();
    end
  endtask

  // 3. Multiple writes then reads
  task test_multiple_write_read;
    begin
      $display("==== Multiple Write/Read ====");
      fifo_write(8'h11);
      fifo_write(8'h22);
      fifo_write(8'h33);
      fifo_read();
      fifo_read();
      fifo_read();
    end
  endtask

  // 4. Fill FIFO (Full condition)
  task test_fill_fifo;
    integer i;
    begin
      $display("==== Fill FIFO ====");
      for (i = 0; i < FIFO_DEPTH; i=i+1)
        fifo_write(i);
      if (full)
        $display("PASS: FIFO full detected.");
      else
        $display("FAIL: FIFO full not detected!");
    end
  endtask

  // 5. Overflow write attempt
  task test_overflow;
    begin
      $display("==== Overflow Write ====");
      fifo_write(8'hFF); // attempt extra write
      if (full)
        $display("PASS: Overflow prevented.");
      else
        $display("FAIL: Overflow not handled!");
    end
  endtask

  // 6. Empty FIFO read
  task test_underflow;
    begin
      $display("==== Underflow Read ====");
      reset_dut();
      fifo_read(); // attempt read
      if (empty)
        $display("PASS: Underflow handled.");
      else
        $display("FAIL: Underflow failed!");
    end
  endtask

  // 7. Simultaneous read & write
  task test_simultaneous_rw;
    begin
      $display("==== Simultaneous Read/Write ====");
      fifo_write(8'h55);
      fifo_write(8'h77);
      @(posedge clk);
      wr_en <= 1; rd_en <= 1; data_in <= 8'h99;
      @(posedge clk);
      wr_en <= 0; rd_en <= 0;
      $display("Simultaneous RW done.");
    end
  endtask

  // 8. Wrap-around write/read
  task test_wraparound;
    integer i;
    begin
      $display("==== Wrap-around ====");
      for (i=0; i<FIFO_DEPTH; i=i+1) fifo_write(i);
      for (i=0; i<4; i=i+1) fifo_read();
      for (i=8'hA0; i<8'hA4; i=i+1) fifo_write(i);
      while (!empty) fifo_read();
    end
  endtask

  // 9. Continuous read until empty
  task test_read_until_empty;
    begin
      $display("==== Read Until Empty ====");
      fifo_write(8'h10);
      fifo_write(8'h20);
      fifo_read();
      fifo_read();
      fifo_read(); // extra read attempt
    end
  endtask

  // 10. Continuous write until full
  task test_write_until_full;
    integer i;
    begin
      $display("==== Write Until Full ====");
      for (i=0; i<FIFO_DEPTH+2; i=i+1)
        fifo_write(i+8'hC0);
    end
  endtask

  // 11. Check data ordering (FIFO property)
  task test_fifo_ordering;
    begin
      $display("==== FIFO Ordering ====");
      fifo_write(8'hAA);
      fifo_write(8'hBB);
      fifo_write(8'hCC);
      fifo_read();
      fifo_read();
      fifo_read();
    end
  endtask

  // 12. Randomized write/read sequence
  task test_random_rw;
    integer i;
    begin
      $display("==== Random RW ====");
      for (i=0; i<20; i=i+1) begin
        if ($urandom%2) fifo_write($random);
        else if (!empty) fifo_read();
      end
    end
  endtask

  // 13. Partial fill + empty
  task test_partial_fill_empty;
    begin
      $display("==== Partial Fill/Empty ====");
      fifo_write(8'hD1);
      fifo_write(8'hD2);
      fifo_read();
      fifo_write(8'hD3);
      fifo_read();
      fifo_read();
    end
  endtask

  // 14. Full -> partial read -> refill
  task test_full_partial_refill;
    integer i;
    begin
      $display("==== Full->Partial->Refill ====");
      for (i=0; i<FIFO_DEPTH; i=i+1) fifo_write(i);
      for (i=0; i<4; i=i+1) fifo_read();
      for (i=8'hE0; i<8'hE4; i=i+1) fifo_write(i);
    end
  endtask

  // 15. Long random stress test
  task test_long_random;
    integer i;
    begin
      $display("==== Long Random Stress ====");
      for (i=0; i<100; i=i+1) begin
        if ($urandom%3 == 0) fifo_write($urandom);
        else if ($urandom%3 == 1 && !empty) fifo_read();
        @(posedge clk);
      end
    end
  endtask

  // --------------------
  // Test Sequencer
  // --------------------
  initial begin
    reset_dut();
    test_reset();
    test_single_write_read();
    test_multiple_write_read();
    test_fill_fifo();
    test_overflow();
    test_underflow();
    test_simultaneous_rw();
    test_wraparound();
    test_read_until_empty();
    test_write_until_full();
    test_fifo_ordering();
    test_random_rw();
    test_partial_fill_empty();
    test_full_partial_refill();
    test_long_random();
    $display("==== All Tests Completed ====");
    $finish;
  end
  initial begin
    $dumpfile("fifo_sync");
    $dumpvars(0,tb_fifo_sync);
  end

endmodule
