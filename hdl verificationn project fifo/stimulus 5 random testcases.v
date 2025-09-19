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
Random 1 – Random Write/Read Mix
Purpose: Check FIFO works when writes and reads happen randomly.
Setup: Run for 10 cycles.
Steps: Each cycle, randomly choose to write or read. Write random data if writing.
Expected: Data is correct, no errors, flags show proper status.
Pass: No wrong data, no flag mistakes.
Random 2 – Random Writes Only
Purpose: Check FIFO when only writing random data.
Setup: Run 5 write cycles.
Steps: Write 5 random values, one per clock.
Expected: All data stored, flags show almost-full/full if needed.
Pass: Data stored correctly, flags correct.
Random 3 – Random Reads Only
Purpose: Check FIFO when only reading.
Setup: Run 7 read cycles.
Steps: Read 7 times, see what comes out.
Expected: Valid data if FIFO has data, empty if not.
Pass: No garbage data, empty/underrun handled right.
Random 4 – Random n Writes then Read
Purpose: Check data order for random count.
Setup: Pick random number 1–8.
Steps: Write that many random values, then read same number.
Expected: Reads match writes in same order.
Pass: Data order correct, flags update right.
Random 5 – Full then Drain
Purpose: Check FIFO when filled and then emptied.
Setup: Write 8, then read 8.
Steps: Fill FIFO with 8 random values. Then read all 8.
Expected: Reads give same 8 values in order, flags show full and empty.
Pass: Data correct, flags correct.
