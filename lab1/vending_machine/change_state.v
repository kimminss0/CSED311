`include "vending_machine_def.v"

module change_state (
    clk,
    reset_n,
    current_total_nxt,
    current_total,
    wait_time_nxt,
    wait_time
);

  input clk;
  input reset_n;
  input [`kTotalBits-1:0] current_total_nxt, wait_time_nxt;
  output reg [`kTotalBits-1:0] current_total, wait_time;

  // Sequential circuit to reset or update the states
  always @(posedge clk) begin
    if (!reset_n) begin
      current_total <= 0;
      wait_time <= 0;
    end else begin
      current_total <= current_total_nxt;
      wait_time <= wait_time_nxt;
    end
  end
endmodule
