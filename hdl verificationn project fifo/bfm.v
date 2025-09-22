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
      $display("\n[BFM]---Directed Case 1- Reset sequence");
      rst_n=0; wr_enb=0; rd_enb=0; wr_data=0;
      @(posedge clk); show;
      rst_n=1;
      @(posedge clk); 
    end
  endtask

  // Simple write
  task do_write(input [7:0] data);
    begin
      $display("\n[BFM]---Directed Case 2 – Simple Write");
      wr_enb=1; wr_data=data;
      @(posedge clk); #1; show;
      wr_enb=0;
      @(posedge clk); 
    end
  endtask

  // Simple read
  task do_read(output [7:0] data);
    begin
      $display("\n[BFM]---Directed Case 3 – Simple Read");
      rd_enb=1;
      @(posedge clk); #1;show;
      data=rd_data;
      rd_enb=0;
      @(posedge clk); 
    end
  endtask

 task do_full_write;
    integer i;
    begin
      $display("\n[BFM]--- Directed Case 4 - Filling FIFO completely");
      for (i =0; i<8; i=i+1) begin
        wr_enb=1; wr_data=i+8'h10;
        @(posedge clk); #1; show;
      end
      wr_enb=0;
      @(posedge clk); 
    end
  endtask

  task do_full_read;
    integer i;
    begin
      $display("\n[BFM]--- Directed Case 5 - Draining FIFO completely");
      for (i=0; i<8; i=i+1) begin
        rd_enb=1;
        @(posedge clk); #1; show;
      end
      rd_enb=0;
      @(posedge clk); 
    end
  endtask

endmodule

-----------------------------------------------------------------------------------------------------
// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
 `timescale 1ns/1ps
`include"bfm.sv"
`include"monitor.sv"
`include "checker.sv"

module tb_top;

  reg clk;
  wire rst_n;
  wire [7:0] wr_data;
  wire wr_enb, rd_enb;
  wire [7:0] rd_data;
  wire fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty, fifo_overrun, fifo_underrun;
  reg[7:0]d;
  

  // clock generator
  initial clk = 0;
  always #5 clk = ~clk;

  // BFM instance
  bfm bfm_inst (
    .clk(clk),
    .rst_n(rst_n),
    .wr_data(wr_data),
    .wr_enb(wr_enb),
    .rd_enb(rd_enb),
    .rd_data(rd_data),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_almost_full(fifo_almost_full),
    .fifo_almost_empty(fifo_almost_empty),
    .fifo_overrun(fifo_overrun),
    .fifo_underrun(fifo_underrun)
  );

  // FIFO DUT instance
  fifo dut (
    .clk(clk),
    .rst_n(rst_n),
    .wr_data(wr_data),
    .wr_enb(wr_enb),
    .rd_enb(rd_enb),
    .rd_data(rd_data),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_almost_full(fifo_almost_full),
    .fifo_almost_empty(fifo_almost_empty),
    .fifo_overrun(fifo_overrun),
    .fifo_underrun(fifo_underrun)
  );
    // MONITOR instance
  
  monitor mon_inst (
    .clk(clk),
    .rst_n(rst_n),
    .wr_enb(wr_enb),
    .wr_data(wr_data),
    .rd_enb(rd_enb),
    .rd_data(rd_data),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_almost_full(fifo_almost_full),
    .fifo_almost_empty(fifo_almost_empty),
    .fifo_overrun(fifo_overrun),
    .fifo_underrun(fifo_underrun)
  );
  
  fifo_checker chk_inst (
    .clk(clk),
    .rst_n(rst_n),
    .wr_enb(wr_enb),
    .wr_data(wr_data),
    .rd_enb(rd_enb),
    .rd_data(rd_data),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_overrun(fifo_overrun),
    .fifo_underrun(fifo_underrun)
  );

initial begin
  bfm_inst.do_reset;
  bfm_inst.do_write(8'hAA);
  bfm_inst.do_read(d);
  bfm_inst.do_full_write;
  bfm_inst.do_full_read;
  $finish;
end



endmodule


------------------------------------------------------------------------------------------

