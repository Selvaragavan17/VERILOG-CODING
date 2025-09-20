
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
    input fifo_underrun
);

    reg [7:0] ref_mem [0:7];
    reg [3:0] wr_ptr, rd_ptr, count;


    reg rd_pending;
    reg [7:0] expected_data;

 
    always @(negedge rst_n) begin
        wr_ptr      <= 0;
        rd_ptr      <= 0;
        count       <= 0;
        rd_pending  <= 0;
        expected_data <= 0;
    end


    always @(posedge clk) begin
        if (rst_n) begin
            if (wr_enb && (count < 8)) begin
                ref_mem[wr_ptr[2:0]] <= wr_data;
                wr_ptr <= wr_ptr + 1;
                count  <= count + 1;
              $display("[CHECKER][%0t]---CAPTURE WRITE: %0h at addr=%0d (count---%0d)",
                          $time, wr_data, wr_ptr[2:0], count+1);
            end

            if (rd_enb && (count > 0)) begin
                expected_data <= ref_mem[rd_ptr[2:0]];
                rd_ptr    <= rd_ptr + 1;
                count     <= count - 1;
                rd_pending <= 1;
            end else begin
                rd_pending <= 0;
            end
        end
    end


    always @(posedge clk) begin
        if (rst_n && rd_pending) begin
            if (rd_data !== expected_data) begin
              $display("[CHECKER][%0t]---ERROR: Data mismatch! Expected=%0h Got=%0h",
                          $time, expected_data, rd_data);
            end else begin
              $display("[CHECKER][%0t]---PASS: Data matched (%0h)",
                          $time, rd_data);
            end
        end
    end

    always @(posedge clk) begin
        if (rst_n) begin
            if (fifo_full && (count != 8))
              $display("[CHECKER][%0t]---ERROR: fifo_full asserted wrongly! golden_count=%0d", $time, count);
            if (fifo_empty && (count != 0))
              $display("[CHECKER][%0t]---ERROR: fifo_empty asserted wrongly! golden_count=%0d", $time, count);
            if (fifo_overrun && (count != 8))
              $display("[CHECKER][%0t]---ERROR: fifo_overrun flagged wrongly! golden_count=%0d", $time, count);
            if (fifo_underrun && (count != 0))
              $display("[CHECKER][%0t]---ERROR: fifo_underrun flagged wrongly! golden_count=%0d", $time, count);
        end
    end

endmodule
