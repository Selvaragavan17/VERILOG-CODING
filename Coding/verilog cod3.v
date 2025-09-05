module alu_bfm (
    input  wire       clk,
    input  wire       reset,
    output reg [3:0]  a,
    output reg [3:0]  b,
    output reg [2:0]  sel,
    input  wire [3:0] y
);

    task drive_op(input [3:0] ta, input [3:0] tb, input [2:0] tsel, input [15*8:1] name);
        begin
            @(posedge clk);
            a   = ta;
            b   = tb;
            sel = tsel;
            @(posedge clk);
            $display("BFM: Applied %s a=%0d b=%0d sel=%b -> y=%0d", 
                       name, ta, tb, tsel, y);
        end
    endtask

    task apply_reset;
        begin
            a = 0; b = 0; sel = 0;
            @(posedge clk);
        end
    endtask

endmodule


module tb_top;
    reg clk, reset;
    wire [3:0] a, b;
    wire [2:0] sel;
    wire [3:0] y;

    sequential_alu dut (
        .clk(clk), .reset(reset), .a(a), .b(b), .sel(sel), .y(y)
    );

    alu_bfm bfm (
        .clk(clk), .reset(reset), .a(a), .b(b), .sel(sel), .y(y)
    );


    always #10 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        #25 reset = 0;

        bfm.drive_op(4, 3, 3'b000, "ADD");
        bfm.drive_op(7, 2, 3'b001, "SUB");
        bfm.drive_op(3, 2, 3'b010, "MUL");
        bfm.drive_op($random % 16, $random % 16, 3'b011, "DIV");

        $finish;
    end
endmodule
-------------------------------------------------------------
module alu_monitor (
    input wire clk,
    input wire reset,
    input wire [3:0] a, b,
    input wire [2:0] sel,
    input wire [3:0] y
);


    always @(posedge clk) begin
        if (!reset) begin
            $display("MONITOR: Observed a=%0d b=%0d sel=%b -> y=%0d", a, b, sel, y);
        end
    end

endmodule



    alu_monitor mon (
        .clk(clk), .reset(reset),
        .a(a), .b(b), .sel(sel), .y(y)
    );
---------------------------------------------------------------
module alu_checker (
    input wire clk,
    input wire reset,
    input wire [3:0] a, b,
    input wire [2:0] sel,
    input wire [3:0] y
);

    reg [3:0] exp;

    always @(posedge clk) begin
        if (!reset) begin
            case (sel)
                3'b000: exp = a + b;
                3'b001: exp = a - b;
                3'b010: exp = a * b;
                3'b011: exp = (b != 0) ? (a / b) : 0;
                3'b100: exp = a & b;
                3'b101: exp = ~a;
                3'b110: exp = a | b;
                3'b111: exp = a ^ b;
                default: exp = 0;
            endcase

            if (y === exp)
                $display("CHECKER: PASS a=%0d b=%0d sel=%b -> y=%0d", a, b, sel, y);
            else
                $display("CHECKER: FAIL a=%0d b=%0d sel=%b -> y=%0d (exp=%0d)", 
                          a, b, sel, y, exp);
        end
    end

endmodule



    alu_checker check (
        .clk(clk), .reset(reset),
        .a(a), .b(b), .sel(sel), .y(y)
    );
---------------------------------------------------------------

`timescale 1ns/1ps

module sequential_alu (
    input        clk,
    input        reset,
    input  [3:0] a, b,
    input  [2:0] sel,
    output reg [3:0] y
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            y <= 4'b0000;
        else begin
            case (sel)
                3'b000: y <= a + b;                       // ADD
                3'b001: y <= a - b;                       // SUB
                3'b010: y <= a * b;                       // MUL
                3'b011: y <= (b != 0) ? (a / b) : 0;      // DIV
                3'b100: y <= a & b;                       // AND
                3'b101: y <= ~a;                          // NOT
                3'b110: y <= a | b;                       // OR
                3'b111: y <= a ^ b;                       // XOR
                default: y <= 0;
            endcase
        end
    end
endmodule



module bfm (
    output reg [3:0] a, b,
    output reg [2:0] sel,
    output reg reset,
    input      clk
);


    task drive(input [3:0] ta, input [3:0] tb, input [2:0] tsel);
        begin
            @(posedge clk);
            a    = ta;
            b    = tb;
            sel  = tsel;
        end
    endtask

    task apply_reset;
        begin
            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
        end
    endtask

endmodule



module monitor (
    input clk,
    input [3:0] a, b,
    input [2:0] sel,
    input [3:0] y
);

    always @(posedge clk) begin
        $display("[MONITOR] time=%0t | a=%0d b=%0d sel=%b y=%0d",
                  $time, a, b, sel, y);
    end

endmodule



module checker (
    input clk,
    input [3:0] a, b,
    input [2:0] sel,
    input [3:0] y
);
    reg [3:0] expected;

    always @(*) begin
        case (sel)
            3'b000: expected = a + b;
            3'b001: expected = a - b;
            3'b010: expected = a * b;
            3'b011: expected = (b != 0) ? (a / b) : 0;
            3'b100: expected = a & b;
            3'b101: expected = ~a;
            3'b110: expected = a | b;
            3'b111: expected = a ^ b;
            default: expected = 0;
        endcase
    end

    always @(posedge clk) begin
        if (y !== expected)
            $display("[CHECKER-FAIL] time=%0t | a=%0d b=%0d sel=%b y=%0d exp=%0d",
                      $time, a, b, sel, y, expected);
        else
            $display("[CHECKER-PASS] time=%0t | a=%0d b=%0d sel=%b y=%0d",
                      $time, a, b, sel, y);
    end
endmodule



module tb_top;
    reg clk;
    wire [3:0] a, b;
    wire [2:0] sel;
    wire reset;
    wire [3:0] y;

    sequential_alu dut (.clk(clk), .reset(reset), .a(a), .b(b), .sel(sel), .y(y));

    bfm bfm_inst (.a(a), .b(b), .sel(sel), .reset(reset), .clk(clk));

    monitor mon (.clk(clk), .a(a), .b(b), .sel(sel), .y(y));

    checker chk (.clk(clk), .a(a), .b(b), .sel(sel), .y(y));

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        bfm_inst.apply_reset;

        $display("===== START TESTCASES =====");

        bfm_inst.drive(4, 3, 3'b000);  // ADD
        bfm_inst.drive(7, 2, 3'b001);  // SUB
        bfm_inst.drive(5, 3, 3'b100);  // AND
        bfm_inst.drive(6, 2, 3'b110);  // OR
        bfm_inst.drive(9, 4, 3'b111);  // XOR

        repeat(5) begin
            bfm_inst.drive($random % 16, $random % 16, $random % 8);
        end

        $display("===== END TESTCASES =====");
        #50 $finish;
    end
endmodule
