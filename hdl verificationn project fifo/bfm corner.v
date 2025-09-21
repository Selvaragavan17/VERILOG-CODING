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
      $display("\n[BFM] Reset sequence");
      rst_n=0; wr_enb=0; rd_enb=0; wr_data=0;
      @(posedge clk); show;
      rst_n=1;
      @(posedge clk); 
    end
  endtask

  // Simple write
  task do_write(input [7:0] data);
    begin
      wr_enb=1; wr_data=data;
      @(posedge clk); show;
      wr_enb=0;
      @(posedge clk); 
    end
  endtask

  // Simple read
  task do_read(output [7:0] data);
    begin
      rd_enb=1;
      @(posedge clk); show;
      data=rd_data;
      rd_enb=0;
      @(posedge clk); show;
    end
  endtask

 task corner_write_when_full;
    integer i;
    begin
      $display("\n[BFM]---Corner Case 1 – Write when FIFO is Full");
      for (i=0; i<8; i=i+1) begin
        do_write(i);
      end
      do_write(8'hFF); 
    end
  endtask

  task corner_read_when_empty;
    reg [7:0] tmp;
    integer i;
    begin
      $display("\n[BFM]---Corner Case 2 – Read when FIFO is Empty");
      do_reset();
    end
  endtask

  task corner_almost_full;
    integer i;
    begin
      $display("\n[BFM]---Corner Case 3 – Almost Full Condition");
      do_reset();
      for (i=0; i<6; i=i+1) do_write(i);
      do_write(8'hAA); 
    end
  endtask

  task corner_almost_empty;
    integer i;
    reg [7:0] tmp;
    begin
      $display("\n[BFM]---Corner Case 4 – Almost Empty Condition");
      do_reset();
      for (i=0; i<2; i=i+1) do_write(i);
      do_read(tmp); 
    end
  endtask

  task corner_simul_read_write;
    reg [7:0] tmp;
    begin
      $display("\n[BFM]---Corner Case 5 – Simultaneous Read and Write");
      do_reset();
      do_write(8'h11);
      do_write(8'h22);
      wr_enb=1; wr_data=8'h55;
      rd_enb=1;
      @(posedge clk); show;
      wr_enb=0; rd_enb=0;
      @(posedge clk); show;
    end
  endtask

endmodule


endmodule

initial begin
  bfm_inst.do_reset();
  bfm_inst.corner_write_when_full();
  bfm_inst.corner_read_when_empty();
  bfm_inst.corner_almost_full();
  bfm_inst.corner_almost_empty();
  bfm_inst.corner_simul_read_write();
  $finish;
end
---------------------------------------------------------------------------
Corner Case 1 – Write when FIFO is Full (Overrun check)
Purpose: Check what happens if we try to write data when FIFO is already full.
Setup: Reset FIFO → then write 8 times (make it full).
Steps:
Keep wr_enb = 1 and give data for 8 cycles.
On the 9th cycle, again try to write with new data.
Expected:
fifo_full = 1
fifo_overrun = 1
New data is not stored, old data stays same.
Pass: Overrun flag = 1 and no extra data goes inside.
Corner Case 2 – Read when FIFO is Empty (Underrun check)
Purpose: Check what happens if we try to read data when FIFO is empty.
Setup: Reset FIFO (it will be empty).
Steps:
Keep rd_enb = 1 and try to read.
Expected:
fifo_empty = 1
fifo_underrun = 1
rd_data does not change.
Pass: Underrun flag = 1 and output is not corrupted.
Corner Case 3 – Almost Full Condition
Purpose: Check if FIFO shows "almost full" before becoming fully full.
Setup: Reset FIFO, then write 6 entries.
Steps:
Write 1 more entry (total = 7).
Expected:
fifo_almost_full = 1
fifo_full = 0
fifo_overrun = 0
Pass: Almost full flag turns ON when 7 entries stored.
Corner Case 4 – Almost Empty Condition
Purpose: Check if FIFO shows "almost empty" before becoming fully empty.
Setup: Reset FIFO, write 2 entries.
Steps:
Read 1 entry (now only 1 left).
Expected:
fifo_almost_empty = 1
fifo_empty = 0
fifo_underrun = 0
Pass: Almost empty flag turns ON when 1 entry left.
Corner Case 5 – Simultaneous Read and Write
Purpose: Check if FIFO works fine when read and write happen at the same time.
Setup: Reset FIFO, then write 3 entries.
Steps:
Apply wr_enb = 1 and rd_enb = 1 in the same cycle.
Expected:
Number of entries stays the same.
Correct data comes out for read.
New data goes in for write.
fifo_full and fifo_empty do not change.
Pass: Data out is correct, data in is stored, count is stable.
