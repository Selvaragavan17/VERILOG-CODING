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
