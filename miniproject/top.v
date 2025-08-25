`timescale 1ns / 1ps

module top (
    input clk,             // 50 MHz Clock
    input rst_n,           // Active-low reset
    input async_in,        // Asynchronous start/stop input
    input mode,            // 7-segment mode: 1 - CC, 0 - CA
    output [6:0] out1,     // Ones digit 7-segment output
    output [6:0] out2      // Tens digit 7-segment output
);

    // Internal wires
    wire out_init, sync_out, tick;
    wire [7:0] count_out;

    // Instantiate Synchronizer
    synchronizer u_sync (
        .clk(clk),
        .rst_n(rst_n),
        .async_in(async_in),
        .out_init(out_init),
        .sync_out(sync_out)
    );

    // Instantiate Timer
    timer u_timer (
        .clk(clk),
        .rst_n(rst_n),
        .timer_enb(sync_out),
        .tick(tick)
    );

    // Instantiate 8-bit Decimal Up Counter
    upcounter u_counter (
        .clk(clk),
        .rst_n(rst_n),
        .ce(tick),
        .out_init(out_init),
        .cout(count_out)
    );

    // Instantiate Two 7-Segment Displays
    seg_display u_seg1 (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .in(count_out[3:0]),   // Ones digit
        .out(out1)
    );

    seg_display u_seg2 (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .in(count_out[7:4]),   // Tens digit
        .out(out2)
    );

endmodule


module decimal_counter (
    input clk,
    input rst_n,
    input flag,      // 1 for up, 0 for down
    input ce,        // count enable
    input load,      // load control
    input [3:0] din, // data input
    output reg [3:0] q,
    output reg carry // carry/borrow flag
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 4'd0;
        carry <= 1'b0;
    end else if (load) begin
        q <= din;
        carry <= 1'b0;
    end else if (ce) begin
        if (flag) begin // UP count
            if (q == 4'd9) begin
                q <= 4'd0;
                carry <= 1'b1;
            end else begin
                q <= q + 1;
                carry <= 1'b0;
            end
        end else begin // DOWN count
            if (q == 4'd0) begin
                q <= 4'd9;
                carry <= 1'b1;
            end else begin
                q <= q - 1;
                carry <= 1'b0;
            end
        end
    end
end

endmodule



module seg_display (
    input clk,
    input rst_n,
    input mode,         // 1: Common Cathode, 0: Common Anode
    input [3:0] in,     // 4-bit hex input
    output reg [6:0] out // 7-segment output
);

    reg [6:0] seg_value;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            seg_value <= 7'b0000000;
        else begin
            case (in)
                4'h0: seg_value <= 7'b0111111;
                4'h1: seg_value <= 7'b0000110;
                4'h2: seg_value <= 7'b1011011;
                4'h3: seg_value <= 7'b1001111;
                4'h4: seg_value <= 7'b1100110;
                4'h5: seg_value <= 7'b1101101;
                4'h6: seg_value <= 7'b1111101;
                4'h7: seg_value <= 7'b0000111;
                4'h8: seg_value <= 7'b1111111;
                4'h9: seg_value <= 7'b1101111;
                4'hA: seg_value <= 7'b1110111;
                4'hB: seg_value <= 7'b1111100;
                4'hC: seg_value <= 7'b0111001;
                4'hD: seg_value <= 7'b1011110;
                4'hE: seg_value <= 7'b1111001;
                4'hF: seg_value <= 7'b1110001;
                default: seg_value <= 7'b0000000;
            endcase
        end
    end

    always @(*) begin
        if (mode)
            out = seg_value;       // Common Cathode
        else
            out = ~seg_value;      // Common Anode
    end

endmodule




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




module timer (
  input clk,
  input rst_n,
  input timer_enb,
  output reg tick
);

  reg [2:0] count; // 3-bit counter: 0 to 4

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tick <= 1'b0;
      count <= 3'd0;
    end
    else if (timer_enb) begin
      if (count == 3'd4) begin
        tick <= 1'b1;      // Generate tick every 5 clock cycles
        count <= 3'd0;
      end else begin
        tick <= 1'b0;
        count <= count + 1;
      end
    end else begin
      count <= 3'd0;
      tick <= 1'b0;
    end
  end

endmodule




module upcounter(
    input clk,
    input rst_n,
    input ce,
    input out_init,
    output [7:0] cout
);

    wire [3:0] lsb, msb;

    // ones digit counter
    decimal_counter lsb_counter (
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .load(out_init),
        .flag(1'b1),
        .din(4'd0),
        .q(lsb),
        .carry()
    );

    // tens digit tick when lsb == 9 and counting enabled
    wire msb_tick = ce & ~out_init & (lsb == 4'd9);

    // tens digit counter
    decimal_counter msb_counter (
        .clk(clk),
        .rst_n(rst_n),
        .ce(msb_tick),
        .load(out_init),
        .flag(1'b1),
        .din(4'd0),
        .q(msb),
        .carry()
    );

    assign cout = (msb * 8'd10) + lsb;
endmodule
