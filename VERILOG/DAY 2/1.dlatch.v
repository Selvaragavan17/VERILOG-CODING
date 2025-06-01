//design code
module dlatch(
  input en,d,
   output reg q);
 always@(*)begin
   if(en)
     q=d;
  end
endmodule
//testbench
module dlatch_tb;
reg en,d;                                                                     
wire q;                                                                         
  dlatch uut(.en(en),.d(d),.q(q));                                              
  initial begin                                                               
    en=0;#5;                                                                    
    d=1;#5;                                                                   
    en=1;#5;                                                                    
    d=0;#5;                                                                    
    d=0;#5;                                                                    
    en=1;#5;                                                                    
  end                                                                          
  initial begin                                                               
    $monitor("time=%0t en=%b d=%b q=%b",$time,en,d,q);                          
  end                                                                          
  initial begin                                                               
    $dumpfile("dlatch.vcd");                                                   
    $dumpvars(1,dlatch_tb);                                                   
  end                                                                         
endmodule 
