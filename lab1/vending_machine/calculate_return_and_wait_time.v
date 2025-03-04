`include "vending_machine_def.v"

module calculate_return_and_wait_time (
    clk,
    reset_n,
    i_trigger_return,
    i_input_coin,
    output_item_nxt,
    wait_time,
    return_changes
);

  input clk;
  input reset_n;
  output reg [`kTotalBits-1:0] wait_time;
  input i_trigger_return;
  input [`kNumCoins-1:0] i_input_coin;
  input [`kNumItems-1:0] output_item_nxt;
  output reg return_changes;

  reg [`kTotalBits-1:0] wait_time_nxt;

  initial begin
    wait_time = 0;
  end

  // Combinational logic for asynchronous calculation
  always @(*) begin
    return_changes = 0;
    wait_time_nxt  = wait_time - 1;

    // Return changes on time over or manual return
    if (wait_time == 0 || i_trigger_return) begin
      return_changes = 1;
    end

    // Initialize waiting time on coin insert or item purchased
    if (i_input_coin != 0 || output_item_nxt != 0) begin
      wait_time_nxt = 100;
    end
  end

  // Sequential logic for updating wait_time
  always @(posedge clk) begin
    if (!reset_n) begin
      wait_time <= 0;
    end else begin
      wait_time <= wait_time_nxt;
    end
  end
endmodule
