`timescale 1ns/1ps

module synchronizer (
    input wire clk,         // 50 MHz system clock
    input wire rst_n,       // asynchronous active-low reset
    input wire async_in,    // asynchronous start/stop toggle switch
    output reg out_init,    // one-cycle pulse at start trigger
    output reg sync_out     // high between start and stop
);

    reg sync_ff1, sync_ff2;
    reg prev_state;

    // Synchronizer Flip-Flops
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;
        end else begin
            sync_ff1 <= async_in;
            sync_ff2 <= sync_ff1;
        end
    end

    // Store previous state for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            prev_state <= 1'b0;
        else
            prev_state <= sync_ff2;
    end

    wire rising_edge  =  sync_ff2 & ~prev_state;  // start trigger
    wire falling_edge = ~sync_ff2 &  prev_state;  // stop trigger

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_out  <= 1'b0;
            out_init  <= 1'b0;
        end else begin
            out_init <= 1'b0;  // default

            if (rising_edge) begin
                sync_out <= 1'b1;  // enable counters
                out_init <= 1'b1;  // initialize counters (1 cycle pulse)
            end else if (falling_edge) begin
                sync_out <= 1'b0;  // disable counters
            end
        end
    end

endmodule

//testbench 
`timescale 1ns/1ps

module tb_synchronizer;

    reg clk;
    reg rst_n;
    reg async_in;
    wire out_init;
    wire sync_out;

    // Instantiate the DUT
    synchronizer dut (
        .clk(clk),
        .rst_n(rst_n),
        .async_in(async_in),
        .out_init(out_init),
        .sync_out(sync_out)
    );

    // Clock generation: 50MHz -> 20ns period
    always #10 clk = ~clk;

    initial begin
        $dumpfile("synchronizer.vcd");
        $dumpvars(0, tb_synchronizer);

        $display("Time\t rst_n async_in | out_init sync_out");
        $monitor("%0t\t %b\t %b\t |   %b\t    %b", $time, rst_n, async_in, out_init, sync_out);
    end

    initial begin
        clk = 0;
        rst_n = 0;
        async_in = 0;

        #25 rst_n = 1;

        #50 async_in = 1; // Rising edge - Start
        #100 async_in = 0; // Falling edge - Stop
        #80  async_in = 1; // Start again
        #60  async_in = 0; // Stop
        #40  async_in = 1; // Start
        #20  async_in = 0; // Stop

        #100 $finish;
    end

endmodule

