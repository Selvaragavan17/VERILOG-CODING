//design code
module nor_gate_cmos (
    input a, b,
    output y);
    supply1 Vdd; 
    supply0 GND; 
    wire w1;
    pmos (y, w1, a);   
    pmos (w1, Vdd, b); 
    nmos (y, GND, a); 
    nmos (y, GND, b);
endmodule

//testbench code
module nor_gate_cmos_tb;
    reg a, b;
    wire y;
    nor_gate_cmos uut (.a(a),.b(b),.y(y));

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
    $dumpfile("nor_gate_cmos.vcd");
    $dumpvars;
  end
endmodule
