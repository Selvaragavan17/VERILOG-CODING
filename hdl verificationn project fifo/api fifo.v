// api_fifo.v
`timescale 1ns/1ps

module api_fifo (
    input  wire clk,
    input  wire rst_n,
    input  wire pass_pulse,   // 1 clk pulse = PASS
    input  wire fail_pulse    // 1 clk pulse = FAIL
);

    integer pass_count;
    integer fail_count;
    integer log_fd;   

    initial begin
        pass_count = 0;
        fail_count = 0;
        log_fd = $fopen("fifo_log.txt", "w");  
        if (log_fd == 0) begin
            $display("ERROR: Could not open fifo_log.txt");
            $finish;
        end
        $fdisplay(log_fd, "==== FIFO Verification Log ====");
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pass_count <= 0;
            fail_count <= 0;
        end else begin
            if (pass_pulse) begin
                pass_count <= pass_count + 1;
                $display("[%0t] PASS detected, total_pass = %0d", $time, pass_count);
                $fdisplay(log_fd, "[%0t] PASS detected, total_pass = %0d", $time, pass_count);
            end
            if (fail_pulse) begin
                fail_count <= fail_count + 1;
                $display("[%0t] FAIL detected, total_fail = %0d", $time, fail_count);
                $fdisplay(log_fd, "[%0t] FAIL detected, total_fail = %0d", $time, fail_count);
            end
        end
    end

   begin
        $display("===================================");
        $display("Verification Summary (api_fifo)");
        $display("Total PASS = %0d", pass_count);
        $display("Total FAIL = %0d", fail_count);
        if (fail_count == 0)
          $display("Final Result = PASSSSSS ");
        else
          $display("Final Result = FAILLLLL ");
        $display("===================================");

        $fdisplay(log_fd, "===================================");
        $fdisplay(log_fd, "Verification Summary (api_fifo)");
        $fdisplay(log_fd, "Total PASS = %0d", pass_count);
        $fdisplay(log_fd, "Total FAIL = %0d", fail_count);
        if (fail_count == 0)
          $fdisplay(log_fd, "Final Result = PASSSSS ");
        else
          $fdisplay(log_fd, "Final Result = FAILLLL ");
        $fdisplay(log_fd, "===================================");
        $fclose(log_fd);   
    end

endmodule
