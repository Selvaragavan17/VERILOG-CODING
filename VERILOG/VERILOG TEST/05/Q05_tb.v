//testbench code
`timescale 1ns/1ps

module tb_clk_divider;
    reg clk_MHz;
    reg reset;
    wire clk_Hz;


    clk_divider_Hz uut (.clk_MHz(clk_MHz),.reset(reset),.clk_Hz(clk_Hz));


    initial begin
        clk_MHz = 0;
        forever #10 clk_MHz = ~clk_MHz; 
    end

    initial begin
        reset = 1;
        #100 reset = 0;
        $monitor("Time = %0t ns: clk_Hz = %b", $time, clk_Hz);
        #10000000 $finish; 
    end
endmodule

//output
Time = 100000 ns: clk_Hz = 0
Time = 5000090000 ns: clk_Hz = 1
Time = 10000090000 ns: clk_Hz = 0
testbench.sv:26: $finish called at 10000100000 (1ps)
