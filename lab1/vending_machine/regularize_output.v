`include "vending_machine_def.v"

module regularize_output (
    available_item_1,
    output_item_1,
    return_coin_1,
    current_total_nxt_1,
    return_changes,
    o_available_item,
    o_output_item,
    o_return_coin,
    current_total_nxt,
    clk,
    reset_n
);
  input clk;
  input reset_n;

  input [`kNumItems-1:0] available_item_1, output_item_1;
  input [`kNumCoins-1:0] return_coin_1;
  input [`kTotalBits-1:0] current_total_nxt_1;
  input return_changes;
  output reg [`kNumItems-1:0] o_available_item, o_output_item;
  output reg [`kNumCoins-1:0] o_return_coin;
  output reg [`kTotalBits-1:0] current_total_nxt;

  always @(*) begin
    if (return_changes) begin
      o_available_item = 0;
      o_return_coin = return_coin_1;
      current_total_nxt = current_total_nxt_1;  // why?
    end else begin
      o_available_item = available_item_1;
      o_return_coin = 0;
      current_total_nxt = current_total_nxt_1;
    end
  end

  always @(posedge clk) begin
    if (!reset_n) begin
      o_output_item <= 0;
    end else begin
      o_output_item <= output_item_1;
    end
  end
endmodule
