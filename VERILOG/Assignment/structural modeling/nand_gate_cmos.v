//design code 
odule nand_gate_cmos (
    input a, b,
    output y);
    supply1 Vdd;   
    supply0 GND;  
    wire w1;
    pmos (y, Vdd, a);  
    pmos (y, Vdd, b);  
    nmos (y, w1, a);   
    nmos (w1, GND, b); 
endmodule

//testbench code
`timescale 1ns/1ps

module nand_gate_cmos_tb;
    reg a, b;
    wire y;
    nand_gate_cmos uut(.a(a),.b(b),.y(y) );

    initial begin
        $display("Time\t a b | y");
        $monitor("%0t\t %b %b | %b", $time, a, b, y);

        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        $finish;
    end
  initial begin
    $dumpfile("nand_gate_cmos.vcd");
    $dumpvars;
  end
endmodule
