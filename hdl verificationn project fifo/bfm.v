`timescale 1ns/1ps
// Simple beginner-friendly BFM for the provided FIFO
// - Pure Verilog
// - Call tasks from testbench via hierarchical name bfm_inst.task_name(...)

module bfm (
    input            clk,             // system clock (shared with FIFO)
    output reg       rst_n,           // drives FIFO reset (active low)
    output reg [7:0] wr_data,         // drives FIFO write data
    output reg       wr_enb,          // drives FIFO write enable
    output reg       rd_enb,          // drives FIFO read enable
    input  [7:0]     rd_data,         // sampled read data from FIFO
    input            fifo_full,
    input            fifo_empty,
    input            fifo_almost_full,
    input            fifo_almost_empty,
    input            fifo_overrun,
    input            fifo_underrun
);

  // -------------------------
  // Helper display
  // -------------------------
  task show;
    begin
      $display("[%0t] wr_enb=%0b wr_data=%0h | rd_enb=%0b rd_data=%0h | full=%0b empty=%0b | almost_full=%0d almost_empty=%0d",
               $time, wr_enb, wr_data, rd_enb, rd_data, fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty);
    end
  endtask

  // -------------------------
  // 1. Reset task
  // -------------------------
  task do_reset;
    begin
      $display("\n[BFM] Reset sequence");
      rst_n = 0;
      wr_enb = 0;
      rd_enb = 0;
      wr_data = 0;
      repeat (2) @(posedge clk);
      rst_n = 1;
      @(posedge clk); #1; show();
    end
  endtask

  // -------------------------
  // 2. Single Write
  // -------------------------
  task do_write(input [7:0] data);
    begin
      $display("\n[BFM] Writing data = %0h", data);
      wr_enb = 1; wr_data = data;
      @(posedge clk); #1; show();
      wr_enb = 0;
      @(posedge clk); #1; show();
    end
  endtask

  // -------------------------
  // 3. Single Read
  // -------------------------
  task do_read(output [7:0] data);
    begin
      $display("\n[BFM] Reading data");
      rd_enb = 1;
      @(posedge clk); #1; show();
      data = rd_data;
      rd_enb = 0;
      @(posedge clk); #1; show();
      $display("[BFM] Got back = %0h", data);
    end
  endtask

  // -------------------------
  // 4. Fill FIFO completely
  // -------------------------
  task do_full_write;
    integer i;
    begin
      $display("\n[BFM] Filling FIFO completely");
      for (i = 0; i < 8; i = i + 1) begin
        wr_enb = 1; wr_data = i + 8'h10;
        @(posedge clk); #1; show();
      end
      wr_enb = 0;
      @(posedge clk); #1; show();
    end
  endtask

  // -------------------------
  // 5. Read FIFO completely
  // -------------------------
  task do_full_read;
    integer i;
    begin
      $display("\n[BFM] Draining FIFO completely");
      for (i = 0; i < 8; i = i + 1) begin
        rd_enb = 1;
        @(posedge clk); #1; show();
      end
      rd_enb = 0;
      @(posedge clk); #1; show();
    end
  endtask

endmodule
-----------------------------------------------------------
  `timescale 1ns/1ps
`include"bfm.sv"


module tb_top;

  reg clk;
  wire rst_n;
  wire [7:0] wr_data;
  wire wr_enb, rd_enb;
  wire [7:0] rd_data;
  wire fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty, fifo_overrun, fifo_underrun;

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
initial begin
  reg [7:0] d;

  bfm_inst.do_reset();
  bfm_inst.do_write(8'hA5);
  bfm_inst.do_read(d);
  bfm_inst.do_full_write();
  bfm_inst.do_full_read();

  #20 $finish;
end



endmodule

