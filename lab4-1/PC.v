module PC (
    input             reset,
    input             clk,
    input             is_stall,
    input      [31:0] next_pc,
    output reg [31:0] current_pc
);
  initial begin
    current_pc = 0;
  end

  always @(posedge clk) begin
    if(reset)
      current_pc <= 0;
    else if (!is_stall)
      current_pc <= next_pc;
    //On else, not change
  end
endmodule
