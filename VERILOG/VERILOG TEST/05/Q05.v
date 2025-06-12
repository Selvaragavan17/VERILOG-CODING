5.Generate a 100Hz clock from a 50MHZ clock in verilog?

//design code
module clk_display(
  input clk,
  input rst,
  output reg out_clk);
  reg[19:0]count;
  
  always@(posedge clk or posedge rst)begin
    if(rst) begin
      count<=19'd0;
      out_clk<=0;
    end
    else begin
      if(count==19'd249999)begin
        count<=19'd0;
        out_clk=~out_clk;
      end
      else
        count<=count+1;
    end
  end
endmodule

