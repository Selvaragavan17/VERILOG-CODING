// Code your design here
module APB_Memory (Pclk, Prst, Paddr, Pselx, Penable, Pwrite, Pwdata, Pready, Pslverr, Prdata, temp);
//input signals of APB Slave
  input Pclk;
  input Prst;
  input [31:0] Paddr;
  input Pselx;
  input Penable;
  input Pwrite;
  input [31:0] Pwdata;

  //output signals of APB Slave
  output reg Pready;
  output reg Pslverr;
  output reg [31:0]Prdata;
  output reg [31:0] temp; // TEMPORARY

  //memory decleration
  reg [31:0] mem [31:0]; // memory

  //state declaration
  parameter [1:0] idle=2'b00;
  parameter [1:0] setup=2'b01;
  parameter [1:0] access=2'b10;
  
  //state declaration of present and next
  reg [1:0] present_state, next_state;
	always@(posedge Pclk or negedge Prst) // async active low reset
      begin
        if (Prst==0) begin
          present_state <= idle;
          next_state <=present_state;
        end
        else
          present_state <= next_state;
      end
  always @(posedge Pclk) begin
    case (present_state)
//Idle phase
      idle:begin
        if (Pselx & ! Penable) //psel =1 and penable =0
          next_state = setup;
      end
//setup phase
setup: begin
  if (Penable & Pselx)
    next_state = access;
  else
    next_state = idle;
end

//access phase
access: begin
  Pready = 1; // Assert Pready during access phase

  if (Pwrite) begin
    mem[Paddr] = Pwdata;
    temp = mem[Paddr];
    Pslverr = 0;
  end else begin
    Prdata = mem[Paddr];
    temp = mem[Paddr];
    Pslverr = 0;
  end

  if (!Penable | !Pselx) begin
    next_state = idle;
    Pready = 0;
  end
end

    endcase
  end
endmodule
