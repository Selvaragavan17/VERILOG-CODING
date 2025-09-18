`timescale 1ns/1ps
`include"stimulus.sv"
// -----------------------------
// tb_top : Testbench top module
// -----------------------------
module tb_top;
    reg clk, rst_n;
    reg wr_enb, rd_enb;
    reg [7:0] wr_data;
    wire [7:0] rd_data;
    wire fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty;
    wire fifo_overrun, fifo_underrun;

    // DUT instantiation
    fifo dut (
        .clk(clk), .rst_n(rst_n),
        .wr_enb(wr_enb), .rd_enb(rd_enb),
        .wr_data(wr_data), .rd_data(rd_data),
        .fifo_full(fifo_full), .fifo_empty(fifo_empty),
        .fifo_almost_full(fifo_almost_full), .fifo_almost_empty(fifo_almost_empty),
        .fifo_overrun(fifo_overrun), .fifo_underrun(fifo_underrun)
    );

    // Clock
    always #5 clk = ~clk;

    // Stimulus module
    stimulus stim (
        .clk(clk), .rst_n(rst_n),
        .wr_enb(wr_enb), .rd_enb(rd_enb),
        .wr_data(wr_data), .rd_data(rd_data),
        .fifo_full(fifo_full), .fifo_empty(fifo_empty),
        .fifo_almost_full(fifo_almost_full), .fifo_almost_empty(fifo_almost_empty),
        .fifo_overrun(fifo_overrun), .fifo_underrun(fifo_underrun)
    );

    initial begin
        clk = 0;
    end
endmodule
