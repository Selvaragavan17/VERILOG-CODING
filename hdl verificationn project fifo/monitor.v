// monitor.v
`timescale 1ns/1ps

module monitor (
    input clk,
    input rst_n,
    input wr_enb,
    input  [7:0]wr_data,
    input rd_enb,
    input  [7:0]rd_data,
    input fifo_full,
    input fifo_empty,
    input fifo_almost_full,
    input fifo_almost_empty,
    input fifo_overrun,
    input fifo_underrun
);

  always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            $display("[%0t][MONITOR] RESET active", $time);
        end else begin
            if (wr_enb && !fifo_full) begin
                $display("[%0t][MONITOR] WRITE : Data=%0h", $time, wr_data);
            end else if (rd_enb && !fifo_empty) begin
                $display("[%0t][MONITOR] READ  : Data=%0h", $time, rd_data);
            end else begin             
                $display("[%0t][MONITOR] No transfer", $time);
            end

            if (fifo_full)         
              $display("[MONITOR] STATUS: FIFO FULL");
            if (fifo_empty)        
              $display("[MONITOR] STATUS: FIFO EMPTY");
            if (fifo_almost_full)               
              $display("[MONITOR] STATUS: FIFO ALMOST FULL");
            if (fifo_almost_empty) 
              $display("[MONITOR] STATUS: FIFO ALMOST EMPTY");
            if (fifo_overrun)      
              $display("[MONITOR] STATUS: FIFO OVERRUN");
            if (fifo_underrun)     
              $display("[MONITOR] STATUS: FIFO UNDERRUN");
        end
    end

endmodule
