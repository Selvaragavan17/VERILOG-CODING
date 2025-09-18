// Code your design here
module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8,
    parameter ADDR_WIDTH = 3   // log2(DEPTH) = 3 for depth 8
)(
    input                   clk,
    input                   rst_n,        // active low async reset
    input  [DATA_WIDTH-1:0] wr_data,
    input                   wr_enb,
    input                   rd_enb,
    output reg [DATA_WIDTH-1:0] rd_data,
    output reg              fifo_full,
    output reg              fifo_empty,
    output reg              fifo_almost_full,
    output reg              fifo_almost_empty,
    output reg              fifo_overrun,
    output reg              fifo_underrun
);

    // FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers
    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;
    reg [ADDR_WIDTH:0] fifo_count;

    // Asynchronous reset + sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr           <= 0;
            rd_ptr           <= 0;
            fifo_count       <= 0;
            fifo_full        <= 0;
            fifo_empty       <= 1;
            fifo_almost_full <= 0;
            fifo_almost_empty<= 1;
            fifo_overrun     <= 0;
            fifo_underrun    <= 0;
            rd_data          <= 0;
        end else begin
            fifo_overrun  <= 0;  // clear on each cycle
            fifo_underrun <= 0;

            // WRITE operation
            if (wr_enb) begin
                if (!fifo_full) begin
                    mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
                    wr_ptr     <= wr_ptr + 1;
                    fifo_count <= fifo_count + 1;
                end else begin
                    fifo_overrun <= 1; // write attempted on full FIFO
                end
            end

            // READ operation
            if (rd_enb) begin
                if (!fifo_empty) begin
                    rd_data    <= mem[rd_ptr[ADDR_WIDTH-1:0]];
                    rd_ptr     <= rd_ptr + 1;
                    fifo_count <= fifo_count - 1;
                end else begin
                    fifo_underrun <= 1; // read attempted on empty FIFO
                end
            end

            // Update flags
            fifo_full         <= (fifo_count == DEPTH);
            fifo_empty        <= (fifo_count == 0);
            fifo_almost_full  <= (fifo_count >= DEPTH-1);
            fifo_almost_empty <= (fifo_count <= 1);
        end
    end
endmodule
