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
  
  // Apply stimulus
  initial begin
    $display("=== FIFO DIRECTED TESTCASES BEGIN ===");
    rst_n = 0;
    wr_enb = 0;
    rd_enb = 0;
    wr_data = 0;

    // Apply reset
    #10;
    rst_n = 1;
    $display("T0: Reset applied → FIFO empty = %b", fifo_empty);
    show();

    // --- TC1: Single Write ---
    #10;
    wr_enb = 1; wr_data = 8'hA5;
    $display("T1: Writing data = %h", wr_data);
    show();
    #10;
    wr_enb = 0;
    #10;$display("    FIFO empty = %b, FIFO full = %b", fifo_empty, fifo_full);
    show();

    // --- TC2: Single Read ---
    #10;
    rd_enb = 1;
    #10;
    $display("T2: Read data = %h", rd_data);
    show();
    rd_enb = 0;
    #10;$display("    FIFO empty = %b, FIFO full = %b", fifo_empty, fifo_full);
    show();

    // --- TC3: Fill FIFO ---
    $display("T3: Filling FIFO with 4 values");
    repeat (4) begin
      wr_enb = 1; wr_data = wr_data + 8'h11; #10;
      $display("    Wrote = %h", wr_data);
      show();
    end
    wr_enb = 0;
    $display("    FIFO full = %b", fifo_full);
    show();

    // --- TC4: Read All Data ---
    
    $display("T4: Reading all data back");
    repeat (4) begin
      rd_enb = 1; #10;
      $display("    Read = %h", rd_data);
      show();
    end
    rd_enb = 0;
    #10;$display("    FIFO empty = %b", fifo_empty);
    show();

     // --- fill FIFO to full (DEPTH = 8) ---
    $display("\nFilling FIFO to full (8 writes)");
    for (i = 0; i < 8; i = i + 1) begin
      wr_enb = 1; wr_data = i + 8'h10;
      @(posedge clk); #1; show();   // capture status right after posedge
    end
    // stop writing
    wr_enb = 0; 
    @(posedge clk); #1; show();

    // --- attempt one extra write -> should assert fifo_overrun for one cycle ---
    $display("\nAttempting extra write to force OVERRUN");
    wr_enb = 1; wr_data = 8'hFF;
    @(posedge clk); #1; show();     // THIS posedge is where fifo_overrun will be set if design works
    // clear write
    wr_enb = 0;
    @(posedge clk); #1; show();     // show next cycle (flag cleared)

    // --- drain FIFO completely ---
    $display("\nDraining FIFO completely (reads)");
    for (i = 0; i < 8; i = i + 1)  begin
      rd_enb = 1;
      @(posedge clk); #1; show();
      rd_enb = 0;
      @(posedge clk); #1;show();
    end

    // --- attempt extra read -> should assert fifo_underrun for one cycle ---
    $display("\nAttempting extra read to force UNDERRUN");
    rd_enb = 1;
    @(posedge clk); #1; show();     // THIS posedge is where fifo_underrun will be set if design works
    rd_enb = 0;
    @(posedge clk); #1; show();     // show next cycle (flag cleared)

    $display("\nFinished overrun/underrun checks");

    $display("=== FIFO DIRECTED TESTCASES END ===");
    $finish;
  end

endmodule
