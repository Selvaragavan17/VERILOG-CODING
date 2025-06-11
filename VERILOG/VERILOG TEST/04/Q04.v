4.4. Implement Y=A/B/C+A.B.E+ IB.C + CID using delay value 3 for and gates,
  2 for or gates and 4 for not gates. Use two inputs and, or gates only. 
  Use $Monitor for displaying result on transcript, also turn off display for 50 time units and
  then continue displaying the results. Note: |B|C means (not B) and (not c) 

//design code
module gates(
  input a,b,c,d,e,
  output reg y);
  
  wire o1,o2,o3,o4;
  wire nb,nc,nd;
  
  not #4 b1(nb,b);
  not #4 b2(nc,b);
  not #4 b3(nb,b);
  
  and #3 a1(o1,a,nb,nc);
  and #3 a2(o2,a,b,e);
  and #3 a3(o3,nb,c);
  and #3 a4(o4,c,nd);
  
  or  #2 c1(y,o1,o2,o3,o4);
endmodule 
