`include "vending_machine_def.v"

module regularize_output (
    available_item_1,
    output_item_nxt,
    return_coin_1,
    current_total_nxt,
    return_changes,
    o_available_item,
    o_output_item,
    o_return_coin,
    current_total,
    clk,
    reset_n
);

  input clk;
  input reset_n;

  input [`kNumItems-1:0] available_item_1, output_item_nxt;
  input [`kNumCoins-1:0] return_coin_1;
  input [`kTotalBits-1:0] current_total_nxt;
  input return_changes;
  output reg [`kNumItems-1:0] o_available_item, o_output_item;
  output reg [`kNumCoins-1:0] o_return_coin;
  output reg [`kTotalBits-1:0] current_total;

  reg reset_current_total;

  initial begin
    o_output_item = 0;
    reset_current_total = 1;
    current_total = 0;
  end

  // Combinational logic for asynchronous calculation
  always @(*) begin
    if (return_changes) begin
      o_available_item = 0;
      o_return_coin = return_coin_1;
    end else begin
      o_available_item = available_item_1;
      o_return_coin = 0;
    end
  end

  // Sequential logic for updating registers
  always @(posedge clk) begin
    if (!reset_n) begin
      o_output_item <= 0;
      current_total <= 0;
      reset_current_total = 1;  // blocking assignment is inevitable
    end else begin
      if (return_changes) begin
        o_output_item <= 0;
        current_total <= reset_current_total ? 0 : current_total_nxt;
      end else begin
        o_output_item <= output_item_nxt;
        current_total <= current_total_nxt;
      end
    end
  end

  // reset current_total at the negedge of return_changes
  always @(posedge return_changes) begin
    reset_current_total = 0;
  end

  always @(negedge return_changes) begin
    reset_current_total = 1;
  end
endmodule
