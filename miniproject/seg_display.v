`timescale 1ns/1ps

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

//testbench code

`timescale 1ns / 1ps

module tb_seg_display;

  reg clk;
  reg rst_n;
  reg mode;
  reg [3:0] in;
  wire [6:0] out;

  // Instantiate the DUT (Design Under Test)
  seg_display dut (
      .clk(clk),
      .rst_n(rst_n),
      .mode(mode),
      .in(in),
      .out(out)
  );

  // 50MHz Clock: Toggle every 10ns
  always #10 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    mode = 1;  // Start in Common Cathode
    in = 4'd0;

    $display("Starting simple testbench for 7-segment...");
    $dumpfile("seg_display.vcd");
    $dumpvars(0, tb_seg_display);
    $monitor("Time=%0t | clk=%b rst_n=%b mode=%b in=%h => out=%b",
              $time, clk, rst_n, mode, in, out);

    // Deassert reset
    #25 rst_n = 1;

    // Test few values in Common Cathode mode
    #20 in = 4'd1;
    #20 in = 4'd2;
    #20 in = 4'd5;
    #20 in = 4'd9;

    // Switch to Common Anode mode
    #20 mode = 0;
    #20 in = 4'd3;
    #20 in = 4'd7;
    #20 in = 4'd10; // A
    #20 in = 4'd15; // F

    $display("Test complete.");
    $finish;
  end

endmodule

