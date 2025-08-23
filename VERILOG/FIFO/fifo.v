
module fifo_sync
    // Parameters section
    #( parameter FIFO_DEPTH = 8,
	   parameter DATA_WIDTH = 8) 
    // Ports section   
	(input clk, 
     input rst_n,
     input cs,     // chip select	 
     input wr_en, 
     input rd_en, 
     input [DATA_WIDTH-1:0] data_in, 
     output reg [DATA_WIDTH-1:0] data_out, 
	 output empty,
	 output full); 

  // log2(FIFO_DEPTH) = address width
  localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH); 
	
  // Declare memory array (FIFO storage)
  reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1]; 
	
  // Write/Read pointers (1 extra MSB bit for full/empty detection)
  reg [FIFO_DEPTH_LOG:0] write_pointer;
  reg [FIFO_DEPTH_LOG:0] read_pointer;

  // -------------------
  // WRITE LOGIC
  // -------------------
  always @(posedge clk or negedge rst_n) begin
      if(!rst_n) // reset active low
          write_pointer <= 0;
      else if (cs && wr_en && !full) begin
          fifo[write_pointer[FIFO_DEPTH_LOG-1:0]] <= data_in;
          write_pointer <= write_pointer + 1'b1;
      end
  end
  
  // -------------------
  // READ LOGIC
  // -------------------
  always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
          read_pointer <= 0;
      else if (cs && rd_en && !empty) begin
          data_out <= fifo[read_pointer[FIFO_DEPTH_LOG-1:0]];
          read_pointer <= read_pointer + 1'b1;
      end
  end
	
  // -------------------
  // STATUS FLAGS
  // -------------------
  assign empty = (read_pointer == write_pointer);
  assign full  = (read_pointer == {~write_pointer[FIFO_DEPTH_LOG],
                                   write_pointer[FIFO_DEPTH_LOG-1:0]});

endmodule
