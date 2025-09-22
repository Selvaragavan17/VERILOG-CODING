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
`timescale 1ns/1ps

module fifo_checker (
    input clk,
    input rst_n,
    input wr_enb,
    input  [7:0] wr_data,
    input rd_enb,
    input  [7:0] rd_data,
    input fifo_full,
    input fifo_empty,
    input fifo_overrun,
    input fifo_underrun,
    input fifo_almost_empty,
    input fifo_almost_full);

    reg [7:0] ref_mem [0:7];
    reg [3:0] wr_ptr, rd_ptr, count;


    reg [7:0] expected_data;
    reg rd_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            rd_pending <= 0;
            expected_data <= 0;
            $display("[%0t][CHECKER] RESET applied", $time);
        end else begin

            if (wr_enb) begin
                if (!fifo_full) begin
                    ref_mem[wr_ptr] <= wr_data;
                    wr_ptr <= wr_ptr + 1;
                    count <= count + 1;
                    $display("[%0t][CHECKER] CAPTURE WRITE: %0h at addr=%0d (count=%0d)",
                             $time, wr_data, wr_ptr, count);
                end else begin
                    if (fifo_overrun)
                        $display("[%0t][CHECKER] PASS : Write blocked (FIFO FULL + OVERRUN)", $time);
                    else
                        $display("[%0t][CHECKER] FAIL : Write attempted but FIFO_FULL not flagged", $time);
                end
            end

            if (rd_pending) begin
                if (rd_data === expected_data)
                    $display("[%0t][CHECKER] PASS : READ data=%0h", $time, rd_data);
                else
                    $display("[%0t][CHECKER] FAIL : READ expected=%0h got=%0h", $time, expected_data, rd_data);
                rd_pending <= 0; // clear after checking
            end

            if (rd_enb) begin
                if (!fifo_empty) begin
                    expected_data <= ref_mem[rd_ptr];
                    rd_ptr <= rd_ptr + 1;
                    count <= count - 1;
                    rd_pending <= 1;
                end else begin
                    if (fifo_underrun)
                        $display("[%0t][CHECKER] PASS : Read blocked (FIFO EMPTY + UNDERRUN)", $time);
                    else
                        $display("[%0t][CHECKER] FAIL : Read attempted but FIFO_EMPTY not flagged", $time);
                end
            end

            if (fifo_full !== (count == 8))
                $display("[%0t][CHECKER] FAIL : fifo_full mismatch (exp=%0b got=%0b)", $time, (count==8), fifo_full);

            if (fifo_empty !== (count == 0))
                $display("[%0t][CHECKER] FAIL : fifo_empty mismatch (exp=%0b got=%0b)", $time, (count==0), fifo_empty);

            if (fifo_almost_full !== (count >= 7))
                $display("[%0t][CHECKER] FAIL : fifo_almost_full mismatch (count=%0d)", $time, count);

            if (fifo_almost_empty !== (count <= 1))
                $display("[%0t][CHECKER] FAIL : fifo_almost_empty mismatch (count=%0d)", $time, count);
        end
    end
endmodule

