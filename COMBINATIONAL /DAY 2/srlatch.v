//design code
module srlatch(
  input en,s,r,
   output reg q);
 always@(*)begin
   if(en == 0)begin
     q=0;
   end
   else begin
     case({s,r})
       2'b00:q=q;
       2'b01:q=1'b0;
       2'b10:q=1'b1;
       2'b11:q=~q; 
     endcase
   end
 end
endmodule


//testbench code
module srlatch_tb;
  reg en,s,r;
  wire q;
  srlatch uut(.en(en),.s(s),.r(r),.q(q));
  initial begin
    en=0;s=0;r=0;#5;
    s=0;r=1;#5;
    s=1;r=0;#5;
    s=1;r=1;#5;
    
    en=1;s=0;r=0;#5;
    s=0;r=1;#5;
    s=1;r=0;#5;
    s=1;r=1;#5;
  end
  
  initial begin
    $dumpfile("srlatch.vcd");
    $dumpvars(1,srlatch_tb);
  end
  initial begin
    $monitor("Time=%0t EN=%b S=%b R=%b Q=%b",$time,en,s,r,q);
  end
endmodule
  
