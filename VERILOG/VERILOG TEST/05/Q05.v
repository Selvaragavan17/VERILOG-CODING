5.Generate a 100Hz clock from a 50MHZ clock in verilog?

//design code
module clk_divider_Hz (
    input clk_MHz,
    input reset,
    output reg clk_1Hz);

    reg [18:0] counter;

    always @(posedge clk_MHz or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_100Hz <= 0;
        end
        else begin
            if (counter == 249999) begin 
                counter <= 0;
                clk_Hz <= ~clk_Hz; 
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
