// Code your design here
// Code your design here
module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8,
    parameter ADDR_WIDTH = 3   // log2(DEPTH) = 3 for depth 8
)(
    input                   clk,
    input                   rst_n,        // active low async reset
    input  [DATA_WIDTH-1:0] wr_data,
    input                   wr_enb,
    input                   rd_enb,
    output reg [DATA_WIDTH-1:0] rd_data,
    output reg              fifo_full,
    output reg              fifo_empty,
    output reg              fifo_almost_full,
    output reg              fifo_almost_empty,
    output reg              fifo_overrun,
    output reg              fifo_underrun
);

    // FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers
    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;
    reg [ADDR_WIDTH:0] fifo_count;

    reg [ADDR_WIDTH:0] next_count;

    // Asynchronous reset + sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr           <= 0;
            rd_ptr           <= 0;
            fifo_count       <= 0;
            fifo_full        <= 0;
            fifo_empty       <= 1;
            fifo_almost_full <= 0;
            fifo_almost_empty<= 1;
            fifo_overrun     <= 0;
            fifo_underrun    <= 0;
            rd_data          <= 0;
        end else begin
            fifo_overrun  <= 0;  // clear each cycle
            fifo_underrun <= 0;

            next_count = fifo_count;

            // WRITE operation
            if (wr_enb) begin
                if (!fifo_full) begin
                    mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
                    wr_ptr     <= wr_ptr + 1;
                    next_count = next_count + 1;
                end else begin
                    fifo_overrun <= 1; // write attempted on full FIFO
                end
            end

            // READ operation
            if (rd_enb) begin
                if (!fifo_empty) begin
                    rd_data    <= mem[rd_ptr[ADDR_WIDTH-1:0]];
                    rd_ptr     <= rd_ptr + 1;
                    next_count = next_count - 1;
                end else begin
                    fifo_underrun <= 1; // read attempted on empty FIFO
                end
            end

            // Update count
            fifo_count <= next_count;

            // Update flags with next_count
            fifo_full         <= (next_count == DEPTH);
            fifo_empty        <= (next_count == 0);
          fifo_almost_full  <= (next_count >= DEPTH-1);
          fifo_almost_empty <= (next_count <= 1);
        end
    end
endmodule
-----------------------------------------------------------------------------

 `timescale 1ns/1ps
`include"bfm.sv"
`include"monitor.sv"
`include"checker.sv"
`include"api_logger.sv"


module tb_top;

  reg clk;
  wire rst_n;
  wire [7:0] wr_data;
  wire wr_enb, rd_enb;
  wire [7:0] rd_data;
  wire fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty, fifo_overrun, fifo_underrun;
  reg[7:0]d;
  wire pass_pulse;
  wire fail_pulse;
  

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
    .fifo_underrun(fifo_underrun),
    .fifo_almost_empty(fifo_almost_empty),
    .fifo_almost_full(fifo_almost_full),
    .pass_pulse(pass_pulse),
    .fail_pulse(fail_pulse)
  );

  api_logger logger_inst (
    .clk(clk),
    .rst_n(rst_n),
    .pass_pulse(pass_pulse),
    .fail_pulse(fail_pulse)
  );


initial begin
  bfm_inst.do_reset;
  bfm_inst.do_write(8'hAA);
  bfm_inst.do_read(d);
  bfm_inst.do_full_write;
  bfm_inst.do_full_read;
  logger_inst.close_log;
  $finish;
end



endmodule
----------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
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

  always @(negedge clk or negedge rst_n) begin
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
---------------------------------------------------------------
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
    input fifo_almost_full,

    output pass_pulse,    // 1-cycle pulse on PASS event
    output fail_pulse     // 1-cycle pulse on FAIL event
);

    // --- Reference FIFO memory and pointers ---
    reg [7:0] ref_mem [0:7];
    reg [3:0] wr_ptr, rd_ptr, count;

    // --- Delayed read check ---
    reg [7:0] expected_data;
    reg rd_pending;

    // pulse regs (internal)
    reg pass_pulse_r;
    reg fail_pulse_r;

    // optional internal counters (kept for debug/reporting)
    integer pass_count;
    integer fail_count;

    // connect outputs
    assign pass_pulse = pass_pulse_r;
    assign fail_pulse = fail_pulse_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            rd_pending <= 0;
            expected_data <= 0;
            pass_pulse_r <= 0;
            fail_pulse_r <= 0;
            pass_count <= 0;
            fail_count <= 0;
            $display("[%0t][CHECKER] RESET applied", $time);
        end else begin
            // clear pulses at start of cycle (single-cycle pulses)
            pass_pulse_r <= 0;
            fail_pulse_r <= 0;

            // ----------------- WRITE -----------------
            if (wr_enb) begin
                if (!fifo_full) begin
                    ref_mem[wr_ptr] <= wr_data;
                    $display("[%0t][CHECKER] CAPTURE WRITE: %0h at addr=%0d (count=%0d)",
                             $time, wr_data, wr_ptr, count);
                    wr_ptr <= wr_ptr + 1;
                    count <= count + 1;
                end else begin
                    if (fifo_overrun) begin
                        $display("[%0t][CHECKER] PASS : Write blocked (FIFO FULL + OVERRUN)", $time);
                        pass_pulse_r <= 1;
                        pass_count = pass_count + 1;
                    end else begin
                        $display("[%0t][CHECKER] FAIL : Write attempted but FIFO_FULL not flagged", $time);
                        fail_pulse_r <= 1;
                        fail_count = fail_count + 1;
                    end
                end
            end

            // -------------- CHECK PREVIOUS READ --------------
            if (rd_pending) begin
                if (rd_data === expected_data) begin
                    $display("[%0t][CHECKER] PASS : READ data=%0h", $time, rd_data);
                    pass_pulse_r <= 1;
                    pass_count = pass_count + 1;
                end else begin
                    $display("[%0t][CHECKER] FAIL : READ expected=%0h got=%0h", $time, expected_data, rd_data);
                    fail_pulse_r <= 1;
                    fail_count = fail_count + 1;
                end
                rd_pending <= 0; // clear after checking
            end

            // ----------------- SCHEDULE NEW READ -----------------
            if (rd_enb) begin
                if (!fifo_empty) begin
                    expected_data <= ref_mem[rd_ptr];
                    rd_ptr <= rd_ptr + 1;
                    count <= count - 1;
                    rd_pending <= 1;
                end else begin
                    if (fifo_underrun) begin
                        $display("[%0t][CHECKER] PASS : Read blocked (FIFO EMPTY + UNDERRUN)", $time);
                        pass_pulse_r <= 1;
                        pass_count = pass_count + 1;
                    end else begin
                        $display("[%0t][CHECKER] FAIL : Read attempted but FIFO_EMPTY not flagged", $time);
                        fail_pulse_r <= 1;
                        fail_count = fail_count + 1;
                    end
                end
            end

            // ----------------- FLAG CHECKS -----------------
            if (fifo_full !== (count == 8)) begin
                $display("[%0t][CHECKER] FAIL : fifo_full mismatch (exp=%0b got=%0b)", $time, (count==8), fifo_full);
                fail_pulse_r <= 1;
                fail_count = fail_count + 1;
            end

            if (fifo_empty !== (count == 0)) begin
                $display("[%0t][CHECKER] FAIL : fifo_empty mismatch (exp=%0b got=%0b)", $time, (count==0), fifo_empty);
                fail_pulse_r <= 1;
                fail_count = fail_count + 1;
            end

            if (fifo_almost_full !== (count >= 7)) begin
                $display("[%0t][CHECKER] FAIL : fifo_almost_full mismatch (count=%0d)", $time, count);
                fail_pulse_r <= 1;
                fail_count = fail_count + 1;
            end

            if (fifo_almost_empty !== (count <= 1)) begin
                $display("[%0t][CHECKER] FAIL : fifo_almost_empty mismatch (count=%0d)", $time, count);
                fail_pulse_r <= 1;
                fail_count = fail_count + 1;
            end
        end
    end

endmodule
--------------------------------------------------------------------

`timescale 1ns/1ps

module api_logger (
    input  clk,
    input  rst_n,
    input  pass_pulse,    // from checker
    input  fail_pulse     // from checker
);

    integer pass_count;
    integer fail_count;
    integer log_fd;

    initial begin
        pass_count = 0;
        fail_count = 0;
        log_fd = $fopen("api_log.txt", "w");
        if (log_fd == 0) begin
            $display("ERROR: Could not open api_log.txt");
            $finish;
        end
        $fwrite(log_fd, "---- FIFO API Log File ----\n");
        $fwrite(log_fd, "Time\tPassCount\tFailCount\n");
        $display("api_logger: opened 'api_log.txt' for logging");
    end

   
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pass_count <= 0;
            fail_count <= 0;
        end else begin
            if (pass_pulse) begin
                pass_count <= pass_count + 1;
             
                $display("[%0t][API_LOG] PASS event: PASS=%0d FAIL=%0d", $time, pass_count+0, fail_count+0);
              
                $fwrite(log_fd, "%0t\tPASS=%0d\tFAIL=%0d\n", $time, pass_count, fail_count);
            end
            if (fail_pulse) begin
                fail_count <= fail_count + 1;
              
                $display("[%0t][API_LOG] FAIL event:  PASS=%0d FAIL=%0d", $time, pass_count+0, fail_count+0);
                
                $fwrite(log_fd, "%0t\tPASS=%0d\tFAIL=%0d\n", $time, pass_count, fail_count);
            end
        end
    end


    task report_status;
    begin
        $display("\n[API_LOG] ===== SUMMARY =====");
        $display("[API_LOG] PASS_COUNT = %0d", pass_count);
        $display("[API_LOG] FAIL_COUNT = %0d", fail_count);
        if (fail_count == 0)
            $display("[API_LOG] VERIFICATION RESULT : PASS");
        else
            $display("[API_LOG] VERIFICATION RESULT : FAIL");
        $display("[API_LOG] ====================\n");

    
        $fwrite(log_fd, "---- SUMMARY ----\n");
        $fwrite(log_fd, "PASS_COUNT = %0d\n", pass_count);
        $fwrite(log_fd, "FAIL_COUNT = %0d\n", fail_count);
        if (fail_count == 0)
            $fwrite(log_fd, "RESULT = PASS\n");
        else
            $fwrite(log_fd, "RESULT = FAIL\n");
    end
    endtask


    task close_log;
    begin
      
        report_status();
        $fwrite(log_fd, "---- Simulation Complete ----\n");
        $fwrite(log_fd, "Total PASS = %0d\n", pass_count);
        $fwrite(log_fd, "Total FAIL = %0d\n", fail_count);
        $fclose(log_fd);
        $display("[API_LOG] Log file closed.");
    end
    endtask

endmodule



