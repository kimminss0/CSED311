// Title         : vending_machine.v
// Author      : Jae-Eon Jo (Jojaeeon@postech.ac.kr)
//			     Dongup Kwon (nankdu7@postech.ac.kr) (2015.03.30)
//			     Jaehun Ryu (jaehunryu@postech.ac.kr) (2021.03.07)

`include "vending_machine_def.v"

module vending_machine (
    clk,  // Clock signal
    reset_n,  // Reset signal (active-low)

    i_input_coin,  // coin is inserted.
    i_select_item,  // item is selected.
    i_trigger_return,  // change-return is triggered 

    o_available_item,  // Sign of the item availability
    o_output_item,  // Sign of the item withdrawal
    o_return_coin  // Sign of the coin return
);

  // Ports Declaration
  // Do not modify the module interface
  input clk;
  input reset_n;

  input [`kNumCoins-1:0] i_input_coin;
  input [`kNumItems-1:0] i_select_item;
  input i_trigger_return;

  output [`kNumItems-1:0] o_available_item;
  output [`kNumItems-1:0] o_output_item;
  output [`kNumCoins-1:0] o_return_coin;


  // Do not modify the values.
  wire [`kTotalBits-1:0] item_price[`kNumItems-1:0];  // Price of each item
  wire [`kTotalBits-1:0] coin_value[`kNumCoins-1:0];  // Value of each coin
  assign item_price[0] = 400;
  assign item_price[1] = 500;
  assign item_price[2] = 1000;
  assign item_price[3] = 2000;
  assign coin_value[0] = 100;
  assign coin_value[1] = 500;
  assign coin_value[2] = 1000;

  // Internal states. You may add your own net variables.
  wire [`kTotalBits-1:0] current_total, wait_time;

  // Next internal states. You may add your own net variables.
  wire [`kTotalBits-1:0] current_total_nxt, wait_time_nxt;


  // Variables. You may add more your own net variables.
  wire [`kNumItems-1:0] available_item_1, output_item_1;
  wire [`kNumCoins-1:0] return_coin_1;
  wire [`kTotalBits-1:0] current_total_nxt_1;
  wire return_changes;

  // This module interface, structure, and given a number of modules are not mandatory but recommended.
  // However, Implementations that use modules are mandatory.
  calculate_intermediate_output calculate_intermediate_output_module (
      .i_input_coin(i_input_coin),
      .i_select_item(i_select_item),
      .current_total(current_total),
      .available_item_1(available_item_1),
      .output_item_1(output_item_1),
      .return_coin_1(return_coin_1),
      .current_total_nxt_1(current_total_nxt_1),
      .item_price(item_price),
      .coin_value(coin_value)
  );

  calculate_return_and_wait_time calculate_return_and_wait_time_module (
      .wait_time(wait_time),
      .i_trigger_return(i_trigger_return),
      .i_input_coin(i_input_coin),
      .output_item_1(output_item_1),
      .wait_time_nxt(wait_time_nxt),
      .return_changes(return_changes)
  );

  regularize_output regularize_output_module (
      .available_item_1(available_item_1),
      .output_item_1(output_item_1),
      .return_coin_1(return_coin_1),
      .current_total_nxt_1(current_total_nxt_1),
      .return_changes(return_changes),
      .o_available_item(o_available_item),
      .o_output_item(o_output_item),
      .o_return_coin(o_return_coin),
      .current_total_nxt(current_total_nxt),
      .clk(clk),
      .reset_n(reset_n)
  );

  change_state change_state_module (
      .clk(clk),
      .reset_n(reset_n),
      .current_total_nxt(current_total_nxt),
      .current_total(current_total),
      .wait_time_nxt(wait_time_nxt),
      .wait_time(wait_time)
  );
endmodule
