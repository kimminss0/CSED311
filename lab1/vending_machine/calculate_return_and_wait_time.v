`include "vending_machine_def.v"

module calculate_return_and_wait_time (
    wait_time,
    i_trigger_return,
    i_input_coin,
    output_item_1,
    wait_time_nxt,
    return_changes
);

  input [31:0] wait_time;
  input i_trigger_return;
  input [`kNumCoins-1:0] i_input_coin;
  input [`kNumItems-1:0] output_item_1;
  output reg [`kTotalBits-1:0] wait_time_nxt;
  output reg return_changes;

  always @(*) begin
    return_changes = 0;
    wait_time_nxt  = wait_time - 1;

    if (wait_time == 0 || i_trigger_return) begin
      return_changes = 1;
      wait_time_nxt  = 100;
    end

    if (i_input_coin != 0 || output_item_1 != 0) begin
      wait_time_nxt = 100;
    end
  end
endmodule
