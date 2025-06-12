//testbench code
`timescale 1ns/1ps

module tb_clk_divider;
    reg clk_50MHz;
    reg reset;
    wire clk_100Hz;


    clk_divider_100Hz uut (.clk_50MHz(clk_50MHz),.reset(reset),.clk_100Hz(clk_100Hz));


    initial begin
        clk_50MHz = 0;
        forever #10 clk_50MHz = ~clk_50MHz; 
    end

    initial begin
        reset = 1;
        #100 reset = 0;
        $monitor("Time = %0t ns: clk_100Hz = %b", $time, clk_100Hz);
        #10000000 $finish; 
    end
endmodule

//output
Time = 100000 ns: clk_100Hz = 0
Time = 5000090000 ns: clk_100Hz = 1
Time = 10000090000 ns: clk_100Hz = 0
testbench.sv:26: $finish called at 10000100000 (1ps)
