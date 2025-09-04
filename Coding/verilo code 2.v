`timescale 1ns/1ps

module sequential_alu (
    input        clk,     
    input        reset, 
    input  [3:0] a, b, 
    input  [2:0] sel, 
    output reg [3:0] y );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 4'b0000;   
        end else begin
            case (sel)
               
                3'b000: y <= a + b;       // Addition
                3'b001: y <= a - b;       // Subtraction
                3'b010: y <= a * b;       // Multiplication (lower 4 bits)
                3'b011: y <= (b != 0) ? (a / b) : 4'b0000; // Division (avoid /0)

                3'b100: y <= a & b;       // AND
                3'b101: y <= ~a;          // NOT (on 'a')
                3'b110: y <= a | b;       // OR
                3'b111: y <= a ^ b;       // XOR

                default: y <= 4'b0000;
            endcase
        end
    end
endmodule


`timescale 1ns/1ps

module tb_sequential_alu;

    reg clk;
    reg reset;
    reg [3:0] a, b;
    reg [2:0] sel;
    wire [3:0] y;

    sequential_alu dut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .sel(sel),
        .y(y));

    always #10 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        a = 0; b = 0; sel = 3'b000;
        #25;        // Wait some time

        reset = 0;  // Release reset
        
        a = 4'd5; b = 4'd3; sel = 3'b000; #20;
        $display("ADD: %0d + %0d = %0d, DUT=%0d", a, b, a+b, y);

        a = 4'd7; b = 4'd2; sel = 3'b001; #20;
        $display("SUB: %0d - %0d = %0d, DUT=%0d", a, b, a-b, y);

        a = 4'd3; b = 4'd2; sel = 3'b010; #20;
        $display("MUL: %0d * %0d = %0d, DUT=%0d", a, b, a*b, y);

        a = 4'd8; b = 4'd2; sel = 3'b011; #20;
        $display("DIV: %0d / %0d = %0d, DUT=%0d", a, b, a/b, y);

        a = 4'b1100; b = 4'b1010; sel = 3'b100; #20;
        $display("AND: %b & %b = %b, DUT=%b", a, b, (a&b), y);

        a = 4'b1010; sel = 3'b101; #20;
        $display("NOT: ~%b = %b, DUT=%b", a, ~a, y);

        a = 4'b1100; b = 4'b0011; sel = 3'b110; #20;
        $display("OR: %b | %b = %b, DUT=%b", a, b, (a|b), y);

        a = 4'b1100; b = 4'b1010; sel = 3'b111; #20;
        $display("XOR: %b ^ %b = %b, DUT=%b", a, b, (a^b), y);
       
        #20;
        $finish;
    end

endmodule

-----------------------------------------------------------------------------------------
module stimulus (
    output reg [3:0] a,
    output reg [3:0] b,
    output reg [2:0] sel,
    output reg reset,
    input  wire clk,
    input  wire [3:0] y
);

    reg [3:0] exp;  

    task run_test(input [3:0] ta, input [3:0] tb, input [2:0] tsel, input [15*8:1] name);
        begin
            a = ta; b = tb; sel = tsel;
            #20;
            case (tsel)
                3'b000: exp = ta + tb;
                3'b001: exp = ta - tb;
                3'b010: exp = ta * tb;
                3'b011: exp = (tb != 0) ? (ta / tb) : 0;
                3'b100: exp = ta & tb;
                3'b101: exp = ~ta;
                3'b110: exp = ta | tb;
                3'b111: exp = ta ^ tb;
                default: exp = 0;
            endcase
            if (y === exp)
                $display("PASS %s: a=%0d b=%0d sel=%b y=%0d", name, ta, tb, tsel, y);
            else
                $display("FAIL %s: a=%0d b=%0d sel=%b y=%0d exp=%0d", name, ta, tb, tsel, y, exp);
        end
    endtask


    task tc01_add; begin run_test(4, 3, 3'b000, "TC-01 ADD"); end endtask
    task tc02_sub; begin run_test(7, 2, 3'b001, "TC-02 SUB"); end endtask
    task tc03_mul; begin run_test(3, 2, 3'b010, "TC-03 MUL"); end endtask

 
    task tc04_div; begin run_test($random % 16, $random % 16, 3'b011, "TC-04 DIV"); end endtask
    task tc05_and; begin run_test($random % 16, $random % 16, 3'b100, "TC-05 AND"); end endtask
    task tc06_xor; begin run_test($random % 16, $random % 16, 3'b111, "TC-06 XOR"); end endtask


    initial begin
        reset = 1; a = 0; b = 0; sel = 0;
        #25 reset = 0;

        $display("===== 3 Directed Tests =====");
        tc01_add;
        tc02_sub;
        tc03_mul;

        $display("===== 3 Random Tests =====");
        tc04_div;
        tc05_and;
        tc06_xor;

        $display("===== Tests Complete =====");
        $finish;
    end
endmodule


module tb_top;
    reg clk;
    wire [3:0] a, b;
    wire [2:0] sel;
    wire reset;
    wire [3:0] y;

    sequential_alu dut (.clk(clk),.reset(reset),.a(a),.b(b),.sel(sel),.y(y));

    stimulus stim (.a(a),.b(b),.sel(sel),.reset(reset),.clk(clk),.y(y));

    always #10 clk = ~clk;

    initial begin
        clk = 0;
    end
endmodule
--------------------------------------------------------------------------------
