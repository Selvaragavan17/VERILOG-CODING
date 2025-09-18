module stimulus(
  input                   clk,
  output reg              rst_n,
  output reg  [7:0]       wr_data,
  output reg              wr_enb,
  output reg              rd_enb,
  input       [7:0]       rd_data,
  input                   fifo_full, fifo_empty,
  input                   fifo_almost_full, fifo_almost_empty,
  input                   fifo_overrun, fifo_underrun
);
  integer i;

  task show;
    begin
      $display("%0t | wr_enb=%0b wr_data=%0h | rd_enb=%0b rd_data=%0h | full=%0b empty=%0b over=%0b under=%0b fifo_almost_full=%0d  fifo_almost_empty=%0d",
               $time, wr_enb, wr_data, rd_enb, rd_data, fifo_full, fifo_empty, fifo_overrun, fifo_underrun,fifo_almost_full,fifo_almost_empty);
    end
  endtask
  

    
    task tc_reset;
    begin
    $display("\n[TC0] Reset sequence");
      rst_n = 0;
      wr_enb = 0;
      rd_enb = 0;
      wr_data = 0;
      repeat(2) @(posedge clk);   
      rst_n = 1;
      @(posedge clk); #1; show();
      end
    endtask

    
    task tc_single_write_read;
    begin
    #10;
    wr_enb = 1; wr_data = 8'hA5;
    $display("T1: Writing data = %h", wr_data);
    show();
    #10;
    wr_enb = 0;
    #10;$display("    FIFO empty = %b, FIFO full = %b", fifo_empty, fifo_full);
    show();
    
  
    rd_enb = 1;
    #10;
    $display("T2: Read data = %h", rd_data);
    show();
    rd_enb = 0;
    #10;$display("    FIFO empty = %b, FIFO full = %b", fifo_empty, fifo_full);
    show();
    end
    endtask

   
     task tc_partial_fill_drain;
    begin
    $display("T3: Filling FIFO with 4 values");
    repeat (4) begin
      wr_enb = 1; wr_data = wr_data + 8'h11; #10;
      $display("    Wrote = %h", wr_data);
      show();
    end
    wr_enb = 0;
    $display("    FIFO full = %b", fifo_full);
    show();

   
    $display("T4: Reading all data back");
    repeat (4) begin
      rd_enb = 1; #10;
      $display("    Read = %h", rd_data);
      show();
    end
    rd_enb = 0;
    #10;$display("    FIFO empty = %b", fifo_empty);
    show();
    end
     endtask

     
    task tc_overrun;
    begin
    $display("\nFilling FIFO to full (8 writes)");
    for (i = 0; i < 8; i = i + 1) begin
      wr_enb = 1; wr_data = i + 8'h10;
      @(posedge clk); #1; show();   
    end
    wr_enb = 0; 
    @(posedge clk); #1; show();

    
    $display("\nAttempting extra write to force OVERRUN");
    wr_enb = 1; wr_data = 8'hFF;
    @(posedge clk); #1; show();     
    
    wr_enb = 0;
    @(posedge clk); #1; show();
    end
    endtask
  

   
    task tc_underrun;
    begin
    $display("\nDraining FIFO completely (reads)");
    for (i = 0; i < 8; i = i + 1)  begin
      rd_enb = 1;
      @(posedge clk); #1; show();
    end
      rd_enb = 0;
      @(posedge clk); #1;show();
    end

    $display("\nAttempting extra read to force UNDERRUN");
    rd_enb = 1;
    @(posedge clk); #1; show();     
    rd_enb = 0;
    @(posedge clk); #1; show();
    endtask


    initial begin
    $display("\n=== FIFO DIRECTED TESTCASES BEGIN ===");

    tc_reset();
    tc_single_write_read();
    tc_partial_fill_drain();
    tc_overrun();
    tc_underrun();

    $display("\n=== FIFO DIRECTED TESTCASES END ===");
    #20 $finish;
  end

endmodule

------------------------------------------------------
TC0 — Reset sequence

Purpose: Ensure FIFO is cleared and stable after reset.
Setup: Start simulation, assert reset for 2 clock cycles.
Steps:

Drive rst_n = 0 for 2 cycles.

Release rst_n = 1.

Observe flags and outputs.
Expected: fifo_empty = 1, fifo_full = 0, no error flags.
Pass: Flags show FIFO is empty immediately after reset.

TC1 — Single write

Purpose: Verify a single write stores data in FIFO.
Setup: FIFO released from reset and empty.
Steps:

Assert wr_enb = 1, drive wr_data = 8'hA5 for one clock.

Deassert wr_enb.

Observe fifo_empty/fifo_full and stored value later when reading.
Expected: FIFO not empty; value A5 will be read out on next read.
Pass: fifo_empty becomes 0 and rd_data returns A5 when read.

TC2 — Single read

Purpose: Verify a single read returns the oldest stored value.
Setup: FIFO contains at least one item (from TC1).
Steps:

Assert rd_enb = 1 for one clock.

Sample rd_data after the posedge.

Deassert rd_enb.
Expected: rd_data equals value written earlier (e.g., A5).
Pass: Read returns expected value and fifo_empty updates accordingly.

TC3 — Partial fill & drain (4 entries)

Purpose: Check FIFO behavior with multiple writes and reads (basic ordering + flags).
Setup: FIFO empty.
Steps:

Write 4 entries sequentially (assert wr_enb, update wr_data each cycle).

Stop writing and then read 4 times (assert rd_enb each cycle).

Observe data order and empty/full flags.
Expected: Reads return the 4 values in the same order written; fifo_empty returns 1 after last read.
Pass: All 4 read values match writes and flags update correctly.

TC4 — Overrun (write when full)

Purpose: Verify FIFO detects and reports an overrun when an extra write is attempted while full.
Setup: Fill FIFO to its maximum depth (8 entries).
Steps:

Write until FIFO is full (8 writes).

Attempt one additional write (assert wr_enb and write any data).

Sample right after the clock edge where the extra write occurs.
Expected: fifo_overrun is asserted for that cycle; fifo_count stays at full; stored data does not change.
Pass: Overrun flag pulses and no corruption of stored data.

TC5 — Underrun (read when empty)

Purpose: Verify FIFO detects and reports an underrun when a read is attempted while empty.
Setup: Drain FIFO completely so it is empty.
Steps:

Read until FIFO is empty.

Attempt one additional read (assert rd_enb for one clock).

Sample right after the posedge where the extra read occurs.
Expected: fifo_underrun is asserted for that cycle; fifo_count remains 0.
Pass: Underrun flag pulses and no invalid data is treated as valid.
