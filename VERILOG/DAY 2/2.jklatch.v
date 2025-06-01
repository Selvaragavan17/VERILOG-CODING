//Design code
module jklatch(
  input en,j,k,
   output reg q);
 always@(*)begin
   if(en)begin
     case({j,k})
       2'b00:q=~q;
       2'b01:q=1'b0;
       2'b10:q=1'b1;
       2'b11:q=q; 
     endcase
   end
 end
endmodule

//testbench code
module jklatch_tb;
  reg en,j,k;
  wire q;
  jklatch uut(.en(en),.j(j),.k(k),.q(q));
  initial begin
    en=0;j=0;k=0;#5;
    j=0;k=1;#5;
    j=1;k=0;#5;
    j=1;k=1;#5;
    
    en=1;j=0;k=0;#5;
    j=0;k=1;#5;
    j=1;k=0;#5;
    j=1;k=1;#5;
  end
  
  initial begin
    $dumpfile("jklatch.vcd");
    $dumpvars(1,jklatch_tb);
  end
  initial begin
    $monitor("Time=%0t EN=%b J=%b K=%b Q=%b",$time,en,j,k,q);
  end
endmodule
