`timescale 1ns/1ps
// bfm.v
module bfm (
    input           clk,
    output reg      rst_n,
    output reg [7:0] wr_data,
    output reg      wr_enb,
    output reg      rd_enb,
    input  [7:0]    rd_data,
    input           fifo_full,
    input           fifo_empty,
    input           fifo_almost_full,
    input           fifo_almost_empty,
    input           fifo_overrun,
    input           fifo_underrun
);

    initial begin
        rst_n   = 1;
        wr_enb  = 0;
        rd_enb  = 0;
        wr_data = 8'h00;
    end
  
  task show;
    begin
      $display("%0t | wr_enb=%0b wr_data=%0h | rd_enb=%0b rd_data=%0h | full=%0b empty=%0b over=%0b under=%0b fifo_almost_full=%0d  fifo_almost_empty=%0d",
               $time, wr_enb, wr_data, rd_enb, rd_data, fifo_full, fifo_empty, fifo_overrun, fifo_underrun,fifo_almost_full,fifo_almost_empty);
    end
  endtask

    // reset
    task reset_bfm;
      input integer cycles;
      integer i;
      begin
        $display("[%0t][BFM] Reset asserted", $time);
        rst_n = 0;
        for (i = 0; i < cycles; i = i + 1) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        $display("[%0t][BFM] Reset de-asserted", $time);
        show();
      end
    endtask

    // write one byte
    task write_byte;
      input [7:0] data;
      begin
        @(posedge clk);
        wr_data = data;
        wr_enb  = 1;
        $display("[%0t][BFM] Wrote %0h", $time, data);
        show();
        @(posedge clk);
        wr_enb  = 0;
      end
    endtask

    // read one byte
    task read_byte; 
      output [7:0] data; 
      begin @(posedge clk); 
        rd_enb = 1; 
        @(posedge clk); 
        data = rd_data; 
        rd_enb = 0; 
        $display("[%0t][BFM] Read %0h", $time, data); 
      end endtask
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

  // Test sequence directly here
  initial begin
    integer i;
    reg [7:0] d;

    // Apply reset
    bfm_inst.reset_bfm(3);

    // Write some values
    for (i = 0; i < 4; i = i + 1) begin
      bfm_inst.write_byte(i);
    end

    // Read them back
    for (i = 0; i < 4; i = i + 1) begin
      bfm_inst.read_byte(d);
      $display("[TB] Got back = %0h", d);
      bfm_inst.show;
    end

    $display("[TB] Test finished!");
    #20 $finish;
  end

endmodule

endmodule
