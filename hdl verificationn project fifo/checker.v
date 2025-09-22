`timescale 1ns/1ps

module fifo_checker (
    input clk,
    input rst_n,
    input wr_enb,
    input  [7:0]wr_data,
    input rd_enb,
    input  [7:0]rd_data,
    input fifo_full,
    input fifo_empty,
    input fifo_overrun,
    input fifo_underrun,
  	input fifo_almost_empty,
  	input fifo_almost_full
);

    reg [7:0] ref_mem [0:7];
    reg [3:0] ref_wr_ptr, ref_rd_ptr, ref_count;

    reg [7:0] expected_data;
    reg [3:0] next_count;

 
    always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    ref_wr_ptr <= 0;
    ref_rd_ptr <= 0;
    ref_count  <= 0;
    expected_data <= 0;
    $display("[%0t][CHECKER] RESET applied",$time);
  end else begin

    next_count = ref_count;

 
    if (wr_enb) begin
      if (!fifo_full) begin
        ref_mem[ref_wr_ptr] <= wr_data;
        ref_wr_ptr <= ref_wr_ptr + 1;
        next_count = next_count + 1;   // blocking ok inside always_ff
        $display("[%0t][CHECKER] CAPTURE WRITE: %0h at addr=%0d (exp_count=%0d)",
                  $time, wr_data, ref_wr_ptr, next_count);
      end else begin
        if (fifo_overrun)
          $display("[%0t][CHECKER] PASS : Write blocked (FIFO FULL + OVERRUN)",$time);
        else
          $display("[%0t][CHECKER] FAIL : Write attempted but FIFO_FULL not flagged",$time);
      end
    end

    if (rd_enb) begin
      if (!fifo_empty) begin
        expected_data = ref_mem[ref_rd_ptr];
        if (rd_data === expected_data)
          $display("[%0t][CHECKER] PASS : READ data=%0h",$time, rd_data);
        else
          $display("[%0t][CHECKER] FAIL : READ expected=%0h got=%0h",
                    $time, expected_data, rd_data);
        ref_rd_ptr <= ref_rd_ptr + 1;
        next_count = next_count - 1;
      end else begin
        if (fifo_underrun)
          $display("[%0t][CHECKER] PASS : Read blocked (FIFO EMPTY + UNDERRUN)",$time);
        else
          $display("[%0t][CHECKER] FAIL : Read attempted but FIFO_EMPTY not flagged",$time);
      end
    end


    ref_count <= next_count;

  
    if (fifo_full !== (ref_count == 8))
      $display("[%0t][CHECKER] FAIL : fifo_full mismatch (exp=%0b got=%0b)",
                $time, (ref_count==8), fifo_full);

    if (fifo_empty !== (ref_count == 0))
      $display("[%0t][CHECKER] FAIL : fifo_empty mismatch (exp=%0b got=%0b)",
                $time, (ref_count==0), fifo_empty);

    if (fifo_almost_full !== (ref_count >= 7))
      $display("[%0t][CHECKER] FAIL : fifo_almost_full mismatch",$time);

    if (fifo_almost_empty !== (ref_count <= 1))
      $display("[%0t][CHECKER] FAIL : fifo_almost_empty mismatch",$time);
  end
end
endmodule
