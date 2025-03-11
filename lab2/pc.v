module pc (
    input             reset,
    input             clk,
    input      [31:0] next_pc,
    output reg [31:0] current_pc
);
  initial begin
    current_pc = 0;
  end

  always @(posedge clk) begin
    current_pc <= reset ? 0 : next_pc;
  end
endmodule
