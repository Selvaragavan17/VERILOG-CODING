module stimulus(
  input clk,
  output reg rst_n,
  output reg  [7:0]wr_data,
  output reg wr_enb,
  output reg rd_enb,
  input [7:0]rd_data,
  input fifo_full, fifo_empty,
  input fifo_almost_full, fifo_almost_empty,
  input fifo_overrun, fifo_underrun);
  integer i;

  task show;
    begin
      $display("%0t | wr_enb=%0b wr_data=%0h | rd_enb=%0b rd_data=%0h | full=%0b empty=%0b over=%0b under=%0b fifo_almost_full=%0d  fifo_almost_empty=%0d",
               $time, wr_enb, wr_data, rd_enb, rd_data, fifo_full, fifo_empty, fifo_overrun, fifo_underrun,fifo_almost_full,fifo_almost_empty);
    end
  endtask
  

 
    task tc_random_write_read;
      integer j;
      begin
        $display("\n--- Random Write/Read Mix ---");
        for (j = 0; j < 10; j = j + 1) begin
          wr_enb  = $random & 1;         // 0 or 1
          rd_enb  = $random & 1;         // 0 or 1
          wr_data = $random & 8'hFF;     // 8-bit safe
          @(posedge clk); #1;
          $display("Cycle %0d: wr_enb=%b wr_data=%h rd_enb=%b rd_data=%h", j, wr_enb, wr_data, rd_enb, rd_data);
          show();
        end
        wr_enb = 0; rd_enb = 0;
      end
    endtask


    task tc_random_writes_only;
      integer j;
      begin
        $display("\n--- Random Writes Only ---");
        for (j = 0; j < 5; j = j + 1) begin
          wr_enb  = 1;
          wr_data = $random & 8'hFF; // keep it in 8-bit range
          @(posedge clk); #1;
          show();
        end
        wr_enb = 0;
      end
    endtask


    task tc_random_reads_only;
      integer j;
      begin
        $display("\n--- Random Reads Only ---");
        for (j = 0; j < 7; j = j + 1) begin
          rd_enb = 1;
          @(posedge clk); #10; show();
        end
        rd_enb = 0;show();
      end
    endtask


    task tc_random_n_write_read;
      integer n, j;
      begin
        n = ($random & 7) + 1; // always 1–8
        $display("\n--- Random n Writes then Reads (n=%0d) ---", n);

        for (j = 0; j < n; j = j + 1) begin
          wr_enb  = 1; 
          wr_data = $random & 8'hFF;
          @(posedge clk); #1; show();
        end
        wr_enb = 0;


        for (j = 0; j < n; j = j + 1) begin
          rd_enb = 1; @(posedge clk); #1; show();
        end
        rd_enb = 0;
      end
    endtask


    task tc_random_full_drain_cycles;
      integer j;
      begin
        $display("\n--- Random Full/Drain Cycle ---");

        for (j = 0; j < 8; j = j + 1) begin
          wr_enb  = 1; wr_data = $random & 8'hFF;
          @(posedge clk); #1; show();
        end
        wr_enb = 0;


        for (j = 0; j < 8; j = j + 1) begin
          rd_enb = 1;
          @(posedge clk); #1; show();
        end
        rd_enb = 0;
      end
    endtask



    initial begin
      rst_n   = 0;
      wr_enb  = 0;
      rd_enb  = 0;
      wr_data = 0;


      $display("Applying reset before tests...");
      repeat(2) @(posedge clk);
      rst_n = 1;
      @(posedge clk);

      $display("\n=== FIFO RANDOM TESTCASES BEGIN ===");

      tc_random_write_read();
      tc_random_writes_only();
      tc_random_reads_only();
      tc_random_n_write_read();
      tc_random_full_drain_cycles();

      $display("\n=== FIFO RANDOM TESTCASES END ===");
      #20 $finish;
    end
endmodule
-------------------------------------------------------------------------------------------
TC6 – Random Write/Read Mix

Purpose: Check FIFO when both writes and reads happen randomly together.

Steps:

For 10 cycles, randomly choose whether to write (wr_enb=1) or not, and read (rd_enb=1) or not.

If writing, send a random 8-bit data value.

If reading, capture whatever comes out.

Expected Result:

No corruption of data.

FIFO must follow proper order (first-in, first-out).

Status flags (full, empty) must behave correctly.

TC7 – Random Writes Only

Purpose: Test FIFO behavior when only random data is written (no reads).

Steps:

Perform 5 writes, each with a random 8-bit value.

Do not read anything.

Expected Result:

FIFO should store all written values in sequence.

If FIFO becomes full, fifo_full must go high.

Data remains inside until a read happens.

TC8 – Random Reads Only

Purpose: Check FIFO response when reads are attempted without enough data.

Steps:

Try 7 consecutive reads, even if the FIFO might be empty.

No new writes are made.

Expected Result:

If FIFO is empty, fifo_empty should go high.

Reading from an empty FIFO should not produce random garbage data (DUT should either keep last value or assert underrun).

TC9 – Random Burst Write then Read

Purpose: Verify FIFO with burst operations (random burst length between 1–8).

Steps:

Pick a random burst length.

Write that many random values continuously into FIFO.

Then read the same number of values back.

Expected Result:

Data written in burst must come out in the same order.

FIFO flags (almost_full, almost_empty) should toggle correctly.

TC10 – Random Full/Drain Cycle

Purpose: Stress test FIFO by filling it completely and then draining it.

Steps:

Write 8 random values (fill FIFO fully).

Then read all 8 values back one by one (drain).

Expected Result:

Data comes out in correct order (first-in-first-out).

After full, fifo_full should go high.

After drain, fifo_empty should go high.
