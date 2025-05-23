module Cache #(
    parameter integer CAPACITY = 256,
    parameter integer BLOCK_SIZE = 16,
    parameter integer GRANULARITY = 4
) (
    input reset,
    input clk,

    input        is_input_valid,  // is request valid?
    input [31:0] addr,            // address of the memory
    input        mem_rw,          // signal indicates whether read or write
    input [31:0] din,             // data to be written

    output reg        is_output_valid,  // is output valid?
    output     [31:0] dout,             // output data
    output reg        is_ready,
    output reg        is_hit
);
  wire mem_read = mem_rw == 0;
  wire mem_write = mem_rw == 1;

  // | TAG | VALID | DIRTY | DATA |
  localparam integer BankWidth = TagWidth + 2 + BLOCK_SIZE * 8;
  localparam integer BankIdxWidth = $clog2(CAPACITY / BLOCK_SIZE);
  localparam integer TagWidth = 32 - $clog2(CAPACITY);
  localparam integer BlockOffsetWidth = $clog2(BLOCK_SIZE / GRANULARITY);

  reg  [       BankWidth-1:0] bank                 [CAPACITY/BLOCK_SIZE];

  wire [        TagWidth-1:0] tag;
  wire [    BankIdxWidth-1:0] bank_idx;
  wire [BlockOffsetWidth-1:0] block_offset;

  wire [BLOCK_SIZE * 8 - 1:0] dmem_din;
  wire [BLOCK_SIZE * 8 - 1:0] dmem_dout;
  reg                         dmem_read;
  reg                         dmem_write;
  wire                        dmem_is_ready;
  wire                        dmem_is_output_valid;
  reg                         dmem_is_input_valid;
  reg  [                31:0] dmem_addr;

  // | 2'b00: write back if dirty; fetch if invalid
  // | 2'b01: write if previous step was write_back
  // | 2'b10: end_fetch
  reg  [                 1:0] state;
  reg                         is_delay;

  assign {tag, bank_idx, block_offset} = addr[31:$clog2(GRANULARITY)];
  assign dmem_din = bank[bank_idx][BLOCK_SIZE*8-1:0];
  assign dout = bank[bank_idx][(block_offset*GRANULARITY*8)+:32];

  DataMemory dmem (
      .reset          (reset),                 // input
      .clk            (clk),                   // input
      .is_input_valid (dmem_is_input_valid),   // input
      .addr           (dmem_addr),             // input
      .din            (dmem_din),              // input
      .mem_read       (dmem_read),             // input
      .mem_write      (dmem_write),            // input
      .is_output_valid(dmem_is_output_valid),  // output
      .dout           (dmem_dout),             // output
      .mem_ready      (dmem_is_ready)          // output
  );
  integer i;
  always @(posedge clk) begin
    if (reset) begin
      for (i = 0; i < CAPACITY / BLOCK_SIZE; i = i + 1) begin
        bank[i] <= 0;
      end
      dmem_read <= 0;
      dmem_write <= 0;
      dmem_is_input_valid <= 0;
      state <= 2'b00;
      is_output_valid <= 0;
      is_hit <= 0;
      is_ready <= 0;
      state <= 0;
      is_delay <= 0;
    end else if (is_input_valid) begin
      if (is_delay) begin
        is_delay <= 0;
        is_output_valid <= 0;
        dmem_write <= 0;
        dmem_read <= 0;
      end else if (mem_read) begin
        if (state == 2'b00 && bank[bank_idx][BankWidth-1-:TagWidth] == tag) begin
          // no fetch from memory
          is_output_valid <= 1;
          is_hit <= 1;
          is_ready <= 1;
          is_delay <= 1;
        end else begin
          if (state == 2'b00) begin
            if (bank[bank_idx][BankWidth-TagWidth-2] == 1) begin  // dirty
              // write back
              is_output_valid <= 0;
              dmem_read <= 0;
              dmem_write <= 1;
              dmem_is_input_valid <= 1;
              dmem_addr <= {
                bank[bank_idx][BankWidth-1-:TagWidth], bank_idx, {$clog2(BLOCK_SIZE) {1'b0}}
              };
              is_hit <= 0;
              is_ready <= 0;
              state <= 2'b01;  // next: fetch_mem
              is_delay <= 1;
            end else begin  // not dirty
              // no write back, just fetch from memory
              is_output_valid <= 0;
              dmem_read <= 1;
              dmem_write <= 0;
              dmem_is_input_valid <= 1;
              dmem_addr <= addr & {{(32 - $clog2(BLOCK_SIZE)) {1'b1}}, {$clog2(BLOCK_SIZE) {1'b0}}};
              is_hit <= 0;
              is_ready <= 0;
              state <= 2'b10;
              is_delay <= 1;
            end
          end else if (state == 2'b01 && dmem_is_ready) begin
            // fetch from memory
            is_output_valid <= 0;
            dmem_read <= 1;
            dmem_write <= 0;
            dmem_is_input_valid <= 1;
            dmem_addr <= addr & {{(32 - $clog2(BLOCK_SIZE)) {1'b1}}, {$clog2(BLOCK_SIZE) {1'b0}}};
            state <= 2'b10;  // next: end_fetch
            is_delay <= 1;
          end else if (state == 2'b10 && dmem_is_output_valid && dmem_is_ready) begin
            is_output_valid <= 1;
            bank[bank_idx] <= {tag, 1'b1, 1'b0, dmem_dout};
            dmem_read <= 0;
            dmem_write <= 0;
            dmem_is_input_valid <= 0;
            is_hit <= 1;
            is_ready <= 1;
            state <= 2'b00;  // next: initial (write_back)
            is_delay <= 1;
          end
        end
      end else if (mem_write) begin
        if (state == 2'b00 && bank[bank_idx][BankWidth-1-:TagWidth] == tag) begin
          is_output_valid <= 1;
          bank[bank_idx][BankWidth-TagWidth-2] <= 1;  // set dirty
          bank[bank_idx][(block_offset*GRANULARITY*8)+:32] <= din;
          is_hit <= 1;
          is_ready <= 1;
          is_delay <= 1;
        end else begin
          if (state == 2'b00) begin
            if (bank[bank_idx][BankWidth-TagWidth-2] == 1) begin  // dirty
              // write back
              is_output_valid <= 0;
              dmem_read <= 0;
              dmem_write <= 1;
              dmem_is_input_valid <= 1;
              dmem_addr <= {
                bank[bank_idx][BankWidth-1-:TagWidth], bank_idx, {$clog2(BLOCK_SIZE) {1'b0}}
              };
              is_hit <= 0;
              is_ready <= 0;
              state <= 2'b01;  // next: fetch_mem
              is_delay <= 1;
            end else begin  // not dirty
              // fetch from memory
              is_output_valid <= 0;
              dmem_read <= 1;
              dmem_write <= 0;
              dmem_is_input_valid <= 1;
              dmem_addr <= addr & {{(32 - $clog2(BLOCK_SIZE)) {1'b1}}, {$clog2(BLOCK_SIZE) {1'b0}}};
              is_hit <= 0;
              is_ready <= 0;
              state <= 2'b10;
              is_delay <= 1;
            end
          end else if (state == 2'b01 && dmem_is_ready) begin
            // fetch from memory
            is_output_valid <= 0;
            dmem_read <= 1;
            dmem_write <= 0;
            dmem_is_input_valid <= 1;
            dmem_addr <= addr & {{(32 - $clog2(BLOCK_SIZE)) {1'b1}}, {$clog2(BLOCK_SIZE) {1'b0}}};
            state <= 2'b10;
            is_delay <= 1;
          end else if (state == 2'b10 && dmem_is_output_valid && dmem_is_ready) begin
            // write to the bank line
            is_output_valid <= 1;
            bank[bank_idx] <= {tag, 1'b1, 1'b1, dmem_dout};  // dirty
            bank[bank_idx][(block_offset*GRANULARITY*8)+:32] <= din;
            dmem_read <= 0;
            dmem_write <= 0;
            dmem_is_input_valid <= 0;
            is_hit <= 1;
            is_ready <= 1;
            state <= 2'b00;
            is_delay <= 1;
          end
        end
      end else begin
        is_hit   <= 0;
        is_delay <= 1;
      end
    end
  end
endmodule
