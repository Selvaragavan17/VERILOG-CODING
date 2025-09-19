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
D1 – Reset behavior
Purpose: Check FIFO clears on reset.
Setup: Reset low (rst_n=0), no read/write.
Steps:
Apply reset.
Wait 1 clock.
Release reset.
Expected: FIFO empty, pointers = 0, flags cleared.
Pass: FIFO shows empty during reset and ready after reset.
D2 – FIFO Order
Purpose: Check data comes out in same order it goes in.
Setup: FIFO empty at start.
Steps:
Write 1, 2, 3 into FIFO.
Stop writing.
Read 3 times.
Expected: Read values = 1, 2, 3.
Pass: Output order matches input order.
D3 – Full/Almost Full Flags
Purpose: Check full and almost-full flags.
Setup: FIFO empty.
Steps:
Keep writing until almost-full, then full.
Stop writing.
Expected: Almost-full flag goes high before full, full flag goes high at max depth.
Pass: Flags toggle exactly at the right levels.
D4 – Overrun
Purpose: Check behavior when writing after full.
Setup: FIFO already full.
Steps:
Try one more write.
Expected: Extra data not stored, overrun flag (if any) set.
Pass: FIFO data safe, overrun handled correctly.
D5 – Underrun
Purpose: Check behavior when reading after empty.
Setup: FIFO already empty.
Steps:
Try one more read.
Expected: No valid data, underrun flag (if any) set.
Pass: FIFO stays empty, underrun handled correctly.
