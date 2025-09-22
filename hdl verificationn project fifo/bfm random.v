`timescale 1ns/1ps

module bfm (
    input clk,             
    output reg       rst_n,           
    output reg [7:0] wr_data,         
    output reg wr_enb,          
    output reg rd_enb,          
    input  [7:0] rd_data,         
    input fifo_full,
    input fifo_empty,
    input fifo_almost_full,
    input fifo_almost_empty,
    input fifo_overrun,
    input fifo_underrun
);

  // Display helper
  task show;
    begin
      $display("[BFM]---[%0t] rst_n=%0b wr_enb=%0b wr_data=%0h | rd_enb=%0b rd_data=%0h | full=%0b empty=%0b | almost_full=%0b almost_empty=%0b overrun=%0b underrun=%0b",$time, rst_n, wr_enb, wr_data, rd_enb, rd_data,
fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty,
fifo_overrun, fifo_underrun);
    end
  endtask

  // Reset sequence
  task do_reset;
    begin
      $display("\n[BFM]--- Reset sequence");
      rst_n=0; wr_enb=0; rd_enb=0; wr_data=0;
      @(posedge clk); show;
      rst_n=1;
      @(posedge clk); 
    end
  endtask

  // Simple write
  task do_write(input [7:0] data);
    begin
//       $display("\n[BFM]---Directed Case 2 – Simple Write");
      wr_enb=1; wr_data=data;
      @(posedge clk); #1; show;
      wr_enb=0;
      @(posedge clk); 
    end
  endtask

  // Simple read
  task do_read(output [7:0] data);
    begin
//       $display("\n[BFM]---Directed Case 3 – Simple Read");
      rd_enb=1;
      @(posedge clk); #1;show;
      data=rd_data;
      rd_enb=0;
      @(posedge clk); 
    end
  endtask

   // -------------------------------
  // RANDOM TESTCASES
  // -------------------------------
  task random_write_read_mix;
    integer i;
    reg [7:0] rand_val, tmp;
    begin
      $display("\n[BFM] Random 1 – Random Write/Read Mix");
      for (i=0; i<4; i=i+1) begin
        if ($random%2) begin
          rand_val = $random;
          $display("[BFM] Random Write = %0h", rand_val);
          do_write(rand_val);
        end else begin
          $display("[BFM] Random Read");
          do_read(tmp);
        end
      end
    end
  endtask


  task random_writes_only;
    integer i;
    reg [7:0] rand_val;
    begin
      $display("\n[BFM] Random 2 – Random Writes Only");
      for (i=0; i<3; i=i+1) begin
        rand_val = $random;
        $display("[BFM] Write = %0h", rand_val);
        do_write(rand_val);
      end
    end
  endtask

  task random_reads_only;
    integer i;
    reg [7:0] tmp;
    begin
      $display("\n[BFM] Random 3 – Random Reads Only");
      for (i=0; i<3; i=i+1) begin
        $display("[BFM] Random Read");
        do_read(tmp);
      end
    end
  endtask

  task random_n_writes_then_reads;
    integer i, n;
    reg [7:0] rand_val, tmp;
    begin
      $display("\n[BFM] Random 4 – Random n Writes then Read");
      n = ($random % 8) + 1;  // 1–8
      $display("[BFM] Writing %0d random values", n);
      for (i=0; i<n; i=i+1) begin
        rand_val = $random;
        do_write(rand_val);
      end
      $display("[BFM] Reading %0d values", n);
      for (i=0; i<n; i=i+1) begin
        do_read(tmp);
      end
    end
  endtask

  task random_full_then_drain;
    integer i;
    reg [7:0] rand_val, tmp;
    begin
      $display("\n[BFM] Random 5 – Full then Drain");
      for (i=0; i<8; i=i+1) begin
        rand_val = $random;
        do_write(rand_val);
      end
      for (i=0; i<8; i=i+1) begin
        do_read(tmp);
      end
    end
  endtask

endmodule
