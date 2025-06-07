//design code
module alu_operation(
  input [3:0]a,b,
  input [2:0]sel,
  output reg carry,
  output reg [3:0]result);
  
  wire [3:0]and_out;
  wire [3:0]or_out;
  wire [3:0]xor_out;
  wire [4:0]add_out;
  wire [4:0]sub_out;
  
  assign and_out=a&b;
  assign or_out=a|b;
  assign xor_out=a^b;
  assign add_out=a+b;
  assign sub_out=a-b;
  
  always@(*)begin
    carry=0;
    case(sel)
      3'd0:result=and_out;
      3'd1:result=or_out;
      3'd2:result=xor_out;
      3'd3:begin
        {carry,result}=add_out;
      end
      3'd4:begin
        {carry,result}=sub_out;
      end
      default:result=4'b0000;
    endcase
  end
endmodule

//testbench code
module alu_operation_tb;
  reg [3:0] a, b;
  reg [2:0] sel;
  wire carry;
  wire [3:0] result;

  alu_operation uut(.a(a),.b(b),.sel(sel),.carry(carry),.result(result));

  initial begin
    $dumpfile("alu_operation.vcd");
    $dumpvars(1,alu_operation_tb);
    $display("Time\tSel\tA\tB\tResult\tCarry");
    $monitor("%0t\t%b\t%b\t%b\t%b\t%b", $time, sel, a, b, result, carry);

    a=4'b1010;b=4'b1100;sel=3'd0;#10;
    sel=3'd1;#10;
    sel=3'd2;#10;
    a=4'b1111;b=4'b0001;sel=3'd3;#10;
    a=4'b1000;b=4'b0011;sel=3'd4;#10;
    a=4'b0011;b=4'b1000;sel=3'd4;#10;
    $finish;
  end
endmodule

//output
Time	Sel	A	B	Result	Carry
  0	000	1010	1100	1000	0
10	001	1010	1100	1110	0
20	010	1010	1100	0110	0
30	011	1111	0001	0000	1
40	100	1000	0011	0101	0
50	100	0011	1000	1011	1
