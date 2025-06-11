4.4. Implement Y=A/B/C+A.B.E+ IB.C + CID using delay value 3 for and gates,
  2 for or gates and 4 for not gates. Use two inputs and, or gates only. 
  Use $Monitor for displaying result on transcript, also turn off display for 50 time units and
  then continue displaying the results. Note: |B|C means (not B) and (not c) 

//design code
`timescale 1ns / 1ps

module logic_expression(
  input A, B, C, D, E,
  output Y
);

  // Internal wires
  wire nB, nC, nD;
  wire and1, and2, and3, and4;
  wire temp1, temp2;
  wire or1, or2;

  // NOT gates with delay 4
  not #4 inv1(nB, B);
  not #4 inv2(nC, C);
  not #4 inv3(nD, D);

  // AND gate: A & ~B
  and #3 a1(temp1, A, nB);
  // AND gate: (A & ~B) & ~C
  and #3 a2(and1, temp1, nC);

  // AND gate: A & B
  and #3 a3(temp2, A, B);
  // AND gate: (A & B) & E
  and #3 a4(and2, temp2, E);

  // AND gate: ~B & ~C
  and #3 a5(and3, nB, nC);

  // AND gate: C & ~D
  and #3 a6(and4, C, nD);

  // OR gates combining all
  or #2 o1(or1, and1, and2);
  or #2 o2(or2, and3, and4);
  or #2 o3(Y, or1, or2);

endmodule
