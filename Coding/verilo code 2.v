`timescale 1ns/1ps

module timing_example;
    reg p, q, r;

    initial begin
        $monitor("Time=%0t | p=%b q=%b r=%b", $time, p, q, r);

        p = 1; q = 0; r = 0;   // statement1 at 0 ns
        #10 p = 1; q = 1;      // statement2 at 10 ns
        #5  q = 1;             // statement3 at 15 ns
        #25 r = 1;             // statement4 at 40 ns
    end
endmodule
