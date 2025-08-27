`timescale 1ns/1ps
module tb_mux4x1;

    reg  [3:0] d;
    reg  [1:0] sel;
    wire y;


    mux4x1 uut (
        .d(d),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("mux4x1_tb.vcd"); // for waveform if using GTKWave
        $dumpvars(0, tb_mux4x1);

        d = 4'b1010;  // d[3]=1, d[2]=0, d[1]=1, d[0]=0

        sel = 2'b00; #10;  
        sel = 2'b01; #10; 
        sel = 2'b10; #10;  
        sel = 2'b11; #10;  

       
        d = 4'b1101;  

        sel = 2'b00; #10;  // expect y = 1
        sel = 2'b01; #10;  // expect y = 0
        sel = 2'b10; #10;  // expect y = 1
        sel = 2'b11; #10;  // expect y = 1

        $finish;
    end
endmodule
