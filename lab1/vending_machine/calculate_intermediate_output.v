`include "vending_machine_def.v"

module calculate_intermediate_output (
    i_input_coin,
    i_select_item,
    current_total,
    available_item_1,
    output_item_nxt,
    return_coin_1,
    current_total_nxt,

    // Constant data
    item_price,
    coin_value
);

  input [`kNumCoins-1:0] i_input_coin;
  input [`kNumItems-1:0] i_select_item;
  input [`kTotalBits-1:0] current_total;
  output reg [`kNumItems-1:0] available_item_1, output_item_nxt;
  output reg [`kNumCoins-1:0] return_coin_1;
  output reg [`kTotalBits-1:0] current_total_nxt;

  input [`kTotalBits-1:0] item_price[`kNumItems];
  input [`kTotalBits-1:0] coin_value[`kNumCoins];

  // Total value of the inserted coins and the price of the selected items
  reg [`kTotalBits-1:0] input_total, price_total;

  // Variables used in for loops
  integer i;
  integer sum_coin;

  // Combinational logic for asynchronous calculation
  always @(*) begin
    // Calculate the available items and price total
    available_item_1 = 0;
    price_total = 0;
    for (i = 0; i < `kNumItems; i++) begin
      if (i_select_item[i]) begin
        price_total += item_price[i];
      end
      if (current_total >= item_price[i]) begin
        available_item_1[i] = 1;
      end
    end

    // Calculate the total value of the inserted coins and the coins to be returned
    input_total = 0;
    return_coin_1 = 0;
    sum_coin = 0;
    for (i = `kNumCoins - 1; i >= 0; i--) begin
      if (i_input_coin[i]) begin
        input_total += coin_value[i];
      end
      if (current_total - sum_coin >= coin_value[i]) begin
        return_coin_1[i] = 1;
        sum_coin += coin_value[i];
      end
    end

    // Check if the items can be purchased
    if (price_total > current_total) begin
      output_item_nxt   = 0;
      current_total_nxt = current_total + input_total;
    end else begin
      output_item_nxt   = i_select_item;
      current_total_nxt = current_total + input_total - price_total;
    end
  end
endmodule
